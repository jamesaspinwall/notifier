json.extract! todo, :id, :context_id, :title, :tags, :description, :show_at, :completed_at, :created_at, :updated_at
json.url todo_url(todo, format: :json)