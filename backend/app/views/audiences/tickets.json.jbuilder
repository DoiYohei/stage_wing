json.array! @tickets do |ticket|
  json.extract! ticket, :id
  json.event do
    json.extract! ticket.event, :id, :name, :date
  end
  json.band do
    json.extract! ticket.band, :id, :name
  end
end
