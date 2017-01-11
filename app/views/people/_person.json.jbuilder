json.extract! person, :id, :phone, :email, :created_at, :updated_at
json.url person_url(person, format: :json)