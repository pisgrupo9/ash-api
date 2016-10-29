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
      get 'users/:id/comments', to: 'users#comments'
      resources :users, only: [:update,:show] do
        resources :reports, only:[:index]
       end
      get 'statistics/animals_by_species', to: 'statistics#animals_by_species'
      get 'statistics/adoptions_by_week', to: 'statistics#adoptions_by_week'
      get 'statistics/entry_by_week', to: 'statistics#entry_by_week'
      get 'animals/search', to: 'animals#search'
      get 'animals/export_search', to: 'animals#export_search'
      get 'animals/:id/export_pdf', to: 'animals#export_pdf', :defaults => { :format => 'json' }
      resources :animals, except: [:new, :edit] do
        resources :images , only: [:create,:destroy,:show, :index]
        get 'events/search', to: 'events#search'
        get 'events/export_events', to: 'events#export_events'
        resources :events, only: [:create,:destroy,:show,:index]
      end
      resources :species, only: [:index]
      get 'adopters/search', to: 'adopters#search'
      post 'adopters/:id/set_as_blacklisted', to: 'adopters#set_as_blacklisted'
      resources :adopters, except: [:new, :edit] do
        resources :comments, except: [:new, :edit, :update]
      end
      resources :adoptions, only: [:create, :show, :destroy]
    end
  end
end
