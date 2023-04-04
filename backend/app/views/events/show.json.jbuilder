json.extract! @event, :id, :name, :place, :date, :open_at, :start_at, :ticket_price, :content, :unregistered_performers, :reservation

if @event.owner
  json.owner do
    json.extract! @event.owner, :id, :name, :image
  end
end

json.flyer @event.flyer.url if @event.flyer

if @event.performers
  json.performers do
    json.array! @event.performers, :id, :name
  end
end

json.ticket @ticket

json.comments do
  parent_comments = @comments.select { |c| c.parent_id.nil? }
  json.array! parent_comments do |parent|
    json.extract! parent, :id, :content, :created_at, :parent_id
    json.commenter do
      if parent.band
        json.extract! parent.band, :id, :name, :image
        json.user_type 'bands'
      else
        json.extract! parent.audience, :id, :name, :image
        json.user_type 'audiences'
      end
    end
    json.replies do
      replies = @comments.select { |c| c.parent_id == parent.id }
      json.array! replies do |reply|
        json.extract! reply, :id, :content, :created_at, :parent_id
        json.commenter do
          if reply.band
            json.extract! reply.band, :id, :name, :image
            json.user_type 'bands'
          else
            json.extract! reply.audience, :id, :name, :image
            json.user_type 'audiences'
          end
        end
      end
    end
  end
end
