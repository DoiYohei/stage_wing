json.array! current_band.performing_events.order(:date) do |event|
  json.extract! event, :id, :name, :date
  json.show false
  json.audiences do
    json.array! @tickets do |ticket|
      if event.id == ticket.event_id
        json.extract! ticket.audience, :name, :image
        json.user_type 'audiences'
      end
    end
  end
end
