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
  json.array! @parent_comments do |comment|
    json.extract! comment, :id, :content, :created_at
    json.commenter do
      if comment.band
        json.extract! comment.band, :id, :name, :image
        json.user_type "bands"
      else
        json.extract! comment.audience, :id, :name, :image
        json.user_type "audiences"
      end
    end
    json.replies do
      replies = @all_comments.select { |a| a.parent_id == comment.id }
      json.array! replies do |reply|
        json.extract! reply, :id, :content, :created_at
        json.commenter do
          if reply.band
            json.extract! reply.band, :id, :name, :image
            json.user_type "bands"
          else
            json.extract! reply.audience, :id, :name, :image
            json.user_type "audiences"
          end
        end
      end
    end
  end
end


