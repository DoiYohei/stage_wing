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
end
