Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'api/v1/api#status'

  devise_for :users, path: 'api/v1/users/', controllers: {
    sessions: 'api/v1/sessions',
    registrations: 'api/v1/registrations',
    passwords: 'api/v1/passwords'
  }

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :users, only: [:update,:show]
      get 'animals/search', to: 'animals#search'
      resources :animals, except: [:new, :edit] do
        resources :images , only: [:create,:destroy,:show, :index]
        get 'events/search', to: 'events#search'
        resources :events, only: [:create,:destroy,:show,:index]
      end
      resources :species, only: [:index]
    end
  end
end
