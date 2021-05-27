if @performers
  json.performers do
    json.array! @performers, :id, :name
  end
end

if @other_performer
  json.unregistered_performers do
    json.id @other_performer.id
    json.name @other_performer.unregistered_performers
  end
end

json.event_id @event.id

if @lineup_ids
  json.lineup_ids do
    json.array! @lineup_ids
  end
end
