Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'sessions' }
  mount_ember_app :frontend, to: "/"

  namespace :v1, defaults: {format: 'json'}do
    jsonapi_resources :events
  end
end
