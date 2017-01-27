Rails.application.routes.draw do
  devise_for :users
  resources :companies
  resources :people
  resources :tags
  resources :categories
  resources :email_reminders
  resources :notices

  resources :todos
  get 'todos/complete/:id', to: 'todos#complete'
  get 'todos/started/:id', to: 'todos#started'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
