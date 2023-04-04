json.array! @events do |event|
  json.extract! event, :id, :name, :date
  json.audiences do
    json.array! @tickets do |ticket|
      json.extract! ticket.audience, :name, :image if event.id == ticket.event_id
    end
  end
end
