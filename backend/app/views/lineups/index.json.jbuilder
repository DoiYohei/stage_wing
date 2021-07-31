if @performers
  json.performers do
    json.array! @performers, :id, :name
  end
end

if @lineup_ids
  json.lineup_ids do
    json.array! @lineup_ids
  end
end
