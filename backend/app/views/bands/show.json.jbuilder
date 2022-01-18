json.extract! @band, :id, :name, :image, :email, :profile, :website, :twitter

json.performing_events do
  json.array! @performing_events, :id, :name, :open_at, :place
end

json.friend_status @friend_status
