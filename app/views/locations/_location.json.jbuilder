json.extract! location, :id, :zipcode, :ip_address, :created_at, :updated_at
json.url location_url(location, format: :json)
