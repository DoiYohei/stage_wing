json.extract! @event, :id, :owner_id, :name, :place, :open_at, :start_at, :ticket_price, :content, :unregistered_performers

if @owner
  json.owner do
    json.extract! @owner, :id, :name, :email
  end
end

json.flyer @flyer
