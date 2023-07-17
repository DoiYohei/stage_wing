json.events do
  json.array! @events, :id, :name, :date, :flyer
end
