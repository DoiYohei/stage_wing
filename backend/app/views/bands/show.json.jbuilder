json.extract! @band, :id, :name, :image, :email, :profile, :website, :twitter

json.performing_events do
  json.array! @performing_events, :id, :name, :open_at, :place
end

json.friend_status @friend_status

json.posts do
  json.array! @posts do |post|
    json.extract! post, :id, :created_at, :format, :photo, :audio, :media_pass, :description, :likes_count
    if @favorite_ids
      json.favorite @favorite_ids.include?(post.id)
    end
  end
end

json.rooms @rooms
