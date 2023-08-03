Rails.application.routes.draw do
  resources :documents, only: [:show]
  get '/health_check', to: 'health_check#index'
end
