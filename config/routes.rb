Rails.application.routes.draw do
  resources :tags
  resources :contexts
  resources :todos
  resources :email_reminders
  resources :notices
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
