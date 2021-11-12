class Comment < ApplicationRecord
  validates :event, :band_or_audience, presence: true
  validates :content, presence: true, length: { maximum: 1000 }

  belongs_to :band, optional: true
  belongs_to :audience, optional: true
  belongs_to :event
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  private

  def band_or_audience
    band.present? ^ audience.present?
  end
end
