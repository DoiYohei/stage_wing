class RoomChannel < ApplicationCable::Channel
  def subscribed
    if params["room"].present?
      stream_from "room_channel_#{params["room"]}"
    else
      reject
    end
  end
  
  def speak(data)
    current_band.messages.create!(room_id: params["room"], content: data["message"])
  end
end
