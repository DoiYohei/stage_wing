json.extract! @band, :id, :name, :email

if @events
  json.performing_events do
    json.array! @events, :id, :name, :open_at
  end
end
