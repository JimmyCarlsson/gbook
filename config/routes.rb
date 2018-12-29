Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'sessions' }
  mount_ember_app :frontend, to: "/"

  namespace :v1, defaults: {format: 'json'}do
    jsonapi_resources :order_rows
    jsonapi_resources :events
    jsonapi_resources :bookings
    resources :invoices, only: [:show], defaults: {format: 'pdf'}
    resources :tickets, only: [:show], defaults: {format: 'pdf'}
    resources :documents, only: [:show, :index], defaults: {format: 'xls'}
    resources :reminder_email, only: [:show]
  end
end
