json.extract! notice, :id, :title, :description, :notify_chronic, :repeat, :notify_at, :sent_at, :cancelled, :created_at, :updated_at
json.url notice_url(notice, format: :json)