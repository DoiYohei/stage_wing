json.array! @tickets do |ticket|
  json.array! ticket.audience, :name
end
