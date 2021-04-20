json.bands do
  json.array! @bands, :id, :name
end
