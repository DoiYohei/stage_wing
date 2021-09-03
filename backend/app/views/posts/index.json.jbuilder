json.posts do
  json.array! @posts, :id, :created_at, :title, :format, :photo, :audio, :media_pass, :description, :likes_count
end

json.liked_post_ids @liked_post_ids
