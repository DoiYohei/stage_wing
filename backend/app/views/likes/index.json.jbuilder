json.array! @posts do |post|
  json.extract! post, :id, :created_at, :format, :photo, :audio, :media_pass, :description, :likes_count, :band_id
  json.favorite true
end
