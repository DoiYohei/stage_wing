json.events do
  json.array! @events, :id, :owner_id, :name, :place, :open_at, :start_at, :content
end
