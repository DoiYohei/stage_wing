json.event do
  json.extract! @event, :id, :owner_id, :name, :place, :open_at, :start_at, :ticket_price, :content
end
if @owner
  json.owner do
    json.extract! @owner, :id, :name, :email
  end
end
