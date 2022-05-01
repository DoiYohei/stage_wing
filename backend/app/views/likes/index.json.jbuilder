json.array! @posts do |post|
  json.extract! post, :id, :created_at, :format, :photo, :audio, :media_pass, :description, :likes_count
  json.band do
    json.extract! post.band, :id, :name, :image
  end
  json.favorite true
end
