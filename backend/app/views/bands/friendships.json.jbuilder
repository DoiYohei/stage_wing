json.ignore_nil!

json.friends do
  json.array! @friends, :id, :name
end

json.inviting do
  json.array! @inviting, :id, :name
end

json.inviters do
  json.array! @inviters, :id, :name
end
