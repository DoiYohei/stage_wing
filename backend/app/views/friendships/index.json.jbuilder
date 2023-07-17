json.friends do
  json.array! current_band.friends do |friend|
    json.extract! friend, :id, :name, :image
    json.friend_state 'friend'
  end
end

json.invitees do
  json.array! current_band.invitees do |invitee|
    json.extract! invitee, :id, :name, :image
    json.friend_state 'inviting'
  end
end

json.inviters do
  json.array! current_band.inviters do |inviter|
    json.extract! inviter, :id, :name, :image
    json.friend_state 'invited'
  end
end
