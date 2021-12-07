json.bands do
  json.array! @bands, :id, :name, :image
end
