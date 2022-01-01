json.bands do
  json.array! @bands, :id, :name
end

json.unregistered_performers @event.unregistered_performers

json.performers do
  json.array! @lineups do |lineup|
    json.extract! lineup.performer, :id, :name
  end
end

json.lineup_ids @lineups.ids
