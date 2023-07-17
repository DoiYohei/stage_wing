json.extract! @band, :id, :name, :image, :email, :profile, :website, :twitter

favorite_ids = current_member.likes.pluck(:post_id) if current_member
json.posts do
  json.array! @band.posts.newest do |post|
    json.extract! post, :id, :created_at, :format, :photo, :audio, :media_pass, :description, :likes_count
    json.band do
      json.extract! @band, :id, :name, :image
    end
    json.favorite favorite_ids.include?(post.id) if current_member
  end
end

json.events do
  json.array! @band.performing_events.order(:date), :id, :name, :flyer, :date
end

if current_band
  json.friend_state current_band.friend_state(@band)
  json.rooms current_band.fetch_rooms
end
