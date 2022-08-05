json.extract! @band, :id, :name, :image, :email, :profile, :website, :twitter

json.posts do
  json.array! @posts do |post|
    json.extract! post, :id, :created_at, :format, :photo, :audio, :media_pass, :description, :likes_count
    json.band do
      json.extract! @band, :id, :name, :image
    end
    json.favorite @favorite_ids.include?(post.id) if @favorite_ids
  end
end

json.events do
  json.array! @events, :id, :name, :flyer, :open_at
end

json.friend_status @friend_status

json.rooms @rooms
