json.ignore_nil!

json.mutual_followers do
  json.array! @mutual_followers, :id, :name
end

json.sending_friend_request do
  json.array! @sending_friend_request, :id, :name
end

json.receiving_friend_request do
  json.array! @receiving_friend_request, :id, :name
end
