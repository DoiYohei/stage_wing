json.array! @posts do |post|
  json.extract! post, :id, :created_at, :format, :photo, :audio, :media_pass, :description, :likes_count, :band_id
  if @favorite_ids
    json.favorite @favorite_ids.include?(post.id)
  end
end
