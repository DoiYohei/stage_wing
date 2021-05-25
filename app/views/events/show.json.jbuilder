json.event do
  json.extract! @event, :id, :owner_id, :name, :place, :open_at, :start_at, :content
end

json.owner do
  if @owner
    json.extract! @owner, :id, :name, :email
  else
    json.null
  end
end

json.performers do
  if @performers
    json.array! @performers, :id, :name
  else
    json.null
  end
end
