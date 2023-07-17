json.messages do
  json.array! @messages do |message|
    json.extract! message, :id, :content, :created_at, :band_id
    json.band_name message.band.name
    json.band_image message.band.image.url
  end
end

json.partner do
  json.extract! @band_room.band, :id, :name, :image
end
