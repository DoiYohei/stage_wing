json.event do
  json.exact! @event, :id, :owner_id, :name, :place, :open_at, :start_at, :content
end
