json.extract! @band, :id, :name, :image, :email, :profile, :website, :twitter
json.image @image

if @events
  json.performing_events do
    json.array! @events, :id, :name, :open_at
  end
end

json.friend_status @friend_status
