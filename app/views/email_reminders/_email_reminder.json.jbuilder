json.extract! email_reminder, :id, :chronic, :title, :description, :created_at, :updated_at
json.url email_reminder_url(email_reminder, format: :json)