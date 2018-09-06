Rails.application.routes.draw do
  namespace :user do
  end
  resources :profile_photos, only: [:create]
  devise_for :users
  get 'user/events/current', to: 'user/events/current#attendees'

  get 'user/profile' => 'user/profile#profile', as: :user_profile
  get 'user/profile/settings' => 'user/profile#settings', as: :user_profile_settings
  get 'user/profile/messages' => 'user/profile#messages', as: :user_profile_messages

  resources :users, :controller=>:users, except: [:new, :create, :index]

  # These don't seem to like namespacing much
  get 'user/events/current/:id/attendees' => 'user/events/current#attendees', as: :attendees_user_current_event
  get 'user/events/current/:id/favorites' => 'user/events/current#favorites', as: :favorites_user_current_event
  get 'user/events/current/:id/inbox' => 'user/events/current#inbox', as: :inbox_user_current_event
  get 'user/events/current/:id' => 'user/events/current#attendees', as: :user_current_event
  post 'user/events/current/:id/message' => 'user/events/current#message_modal', as: :user_current_message_modal


  get 'user/events' => 'user/events#index'
  get 'user', to: 'user/events#index'
  namespace :user do
    resources :events, only: [:show, :index] do
      collection do
        get 'my_events'
        get 'join'
        post 'join'
        post 'modal'
        get 'search'
      end
    end

    resources :private_messages
  end

  get 'admin', to: 'admin/events#index'
  namespace :admin do
    resources :events, :places
  end

  root "user/events#index"
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
