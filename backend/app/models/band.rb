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

  # Bandをフォローする
  def follow(other_band)
    following << other_band
  end

  # Bandをフォロー解除する
  def unfollow(other_band)
    active_friendships.find_by(followed_id: other_band.id).destroy
  end

  # 相互フォローの関係にあるBandを取得
  def mutual_followers
    following & followers
  end

  # 自分はフォローしているが、相手からフォローされていない(友達申請中の)Bandを返す
  def sending_friend_request
    following.where.not(id: followers.ids)
  end

  # 自分はフォローしていないが、相手からフォローされている(友達申請されている)Bandを返す
  def receiving_friend_request
    followers.where.not(id: following.ids)
  end

  # フォローしていたらtrueを返す
  def following?(other_band)
    following.include?(other_band)
  end

  # フォローされていたらtrueを返す
  def followed_by?(other_band)
    followers.include?(other_band)
  end
end
