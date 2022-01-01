json.extract! @event, :id, :name, :place, :open_at, :start_at, :ticket_price, :content, :unregistered_performers, :reservation

if @event.owner
  json.owner do
    json.extract! @event.owner, :id, :name
    json.image @event.owner.image.thumb.url
  end
end

if @event.flyer
  json.flyer @event.flyer.url
end

if @event.performers
  json.performers do
    json.array! @event.performers, :id, :name
  end
end

json.ticket @ticket

json.comments do
  json.array! @comments do |comment|
    json.extract! comment, :id, :content, :parent_id
    json.commenter do
      if comment.band
        json.extract! comment.band, :id, :name
      else
        json.extract! comment.audience, :id, :name
      end
    end
  end
end

json.parent_comments do
  json.array! @parent_comments do |comment|
    json.extract! comment, :id, :content
    json.commenter do
      if comment.band
        json.extract! comment.band, :id, :name
      else
        json.extract! comment.audience, :id, :name
      end
    end
  end
end


