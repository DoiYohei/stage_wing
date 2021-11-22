json.array! @tickets do |ticket|
  json.event do
    json.extract! ticket.event, :id, :name, :open_at
  end
  json.audience ticket.audience.name
end
