json.events do
  json.array! @events, :id, :name, :open_at, :flyer
end
