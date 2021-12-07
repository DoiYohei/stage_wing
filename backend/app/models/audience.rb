# frozen_string_literal: true

class Audience < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, length: { maximum: 20 }

  mount_uploader :image, ImageUploader
  IMAGE_SIZE = [600, 600]
  THUMBNAIL_SIZE = [30, 30]

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :tickets, dependent: :destroy
end
