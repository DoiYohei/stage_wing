json.extract! @event, :name, :open_at, :start_at, :place, :ticket_price

json.lineups do
  json.array! @lineups do |lineup|
    json.extract! lineup.performer, :id, :name
  end 
end
