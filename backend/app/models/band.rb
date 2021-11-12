# frozen_string_literal: true

class Band < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, length: { maximum: 50 }
  validates :profile, length: { maximum: 1000 }
  validates :website, :twitter, format: { with: /\A#{URI::regexp(%w(http https))}\z/ }, allow_nil: true

  mount_uploader :image, ImageUploader

  has_many :created_events, class_name: "Event", foreign_key: "owner_id", dependent: :nullify
  has_many :posts, dependent: :destroy
  has_many :performings, class_name: "Lineup", foreign_key: "performer_id", dependent: :destroy
  has_many :performing_events, class_name: "Event", through: :performings
  has_many :active_friendships, class_name: "Friendship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_friendships, class_name: "Friendship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_friendships, source: :followed
  has_many :followers, through: :passive_friendships, source: :follower
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :band_rooms, dependent: :destroy
  has_many :rooms, through: :band_rooms
  
  # Bandをフォローする
  def follow(other_band)
    active_friendships.create!(followed_id: other_band.id)
  end

  # Bandをフォロー解除する
  def unfollow(followed_id_params)
    active_friendships.find_by(followed_id_params).destroy!
  end

  # 相互フォロー(友達)の関係にあるBandを返す
  def friends
    following & followers
  end

  # 自分はフォローしているが、相手からフォローされていない(友達申請中の)Bandを返す
  def inviting
    following.where.not(id: followers.ids)
  end

  # 自分はフォローしていないが、相手からフォローされている(友達申請されている)Bandを返す
  def inviters
    followers.where.not(id: following.ids)
  end

  # 自分と対象のBandとの関係を返す
  def friend_status(other_band)
    if friends.include?(other_band)
      "friend"
    elsif inviting.include?(other_band)
      "inviting"
    elsif inviters.include?(other_band)
      "invited"
    else
      nil
    end
  end

  # フォローしていたらtrueを返す
  def following?(other_band)
    following.include?(other_band)
  end

  # フォローされていたらtrueを返す
  def followed_by?(other_band)
    followers.include?(other_band)
  end

  # 相互フォロー(友達)関係にあるBandと共通のroom_idを取得
  # そのBandの情報と合わせて新しい配列を作る
  # roomが未作成の場合idにはnullが入る
  def fetch_rooms
    chat_rooms = []
    my_room_ids = rooms.ids
    friends.each do |f|
      friend_room_ids = f.band_rooms.map(&:room_id)
      chat_room_id = friend_room_ids & my_room_ids
      chat_rooms.push({
        id: chat_room_id[0],
        friend_name: f.name,
        friend_id: f.id,
      })
    end
    chat_rooms
  end
end
