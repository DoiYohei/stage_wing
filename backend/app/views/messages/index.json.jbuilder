json.messages do
  json.array! @messages, :content, :created_at, :band_id
end

json.bands do
  json.array! @band_rooms do |b|
    json.extract! b.band, :id, :name
  end
end
