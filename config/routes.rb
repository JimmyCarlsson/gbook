Rails.application.routes.draw do
  mount_ember_app :frontend, to: "/index"

  namespace :v1 do
    jsonapi_resources :events
  end
end
