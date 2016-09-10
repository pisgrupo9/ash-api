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
      get 'users/isanimalsedit', to: 'users#isanimalsedit'
      get 'users/isadoptersedit', to: 'users#isadoptersedit'
      get 'users/isdefaultuser', to: 'users#isdefaultuser'
      resources :users, only: [:update,:index,:show]
      resources :animals, except: [:new, :edit]
      resources :species, only: [:index]
    end
  end
end
