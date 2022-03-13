class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast(
      "room_channel_#{message.room_id}", { content: message.content, created_at: message.created_at, band_id: message.band_id, band_name: message.band.name, band_image: message.band.image.url }
    )
  end
end
