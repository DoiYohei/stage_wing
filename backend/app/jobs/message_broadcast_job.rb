class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast(
      "room_channel_#{message.room_id}", { content: message.content, created_at: message.created_at, band_id: message.band_id }
    )
  end
end
