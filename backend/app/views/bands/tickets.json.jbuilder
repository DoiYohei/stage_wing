json.array! @events do |event|
  json.extract! event, :id, :name, :open_at
  json.audiences do
    json.array! @tickets do |ticket|
      if event.id == ticket.event_id
        json.extract! ticket.audience, :name, :image
      end
    end
  end
end
