json.friends do
  json.array! @friends, :id, :name, :image
end

json.inviting do
  json.array! @inviting, :id, :name, :image
end

json.inviters do
  json.array! @inviters, :id, :name, :image
end
