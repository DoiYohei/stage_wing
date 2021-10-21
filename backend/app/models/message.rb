class Message < ApplicationRecord
  validates :band, presence: true
  validates :room, presence: true
  validates :content, presence: true, length: { maximum: 1000 }

  belongs_to :band
  belongs_to :room

  after_create_commit :broadcast_message

  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end
end
