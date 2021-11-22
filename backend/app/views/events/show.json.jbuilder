json.extract! @event, :id, :owner_id, :name, :place, :open_at, :start_at, :ticket_price, :content, :unregistered_performers, :reservation

json.flyer @flyer

json.performers do
  json.array! @performers, :id, :name
end

json.comments do
  json.array! @comments, :id, :band_id, :audience_id, :content, :parent_id
end

json.parent_comments do
  json.array! @parent_comments,:id, :band_id, :audience_id, :content
end

json.ticket @ticket
