json.array! @tickets do |ticket|
  json.ticket_id ticket.id
  json.event_id ticket.event.id
  json.event_name ticket.event.name
  json.date ticket.event.date
  json.band_id ticket.band.id
  json.band_name ticket.band.name
end
