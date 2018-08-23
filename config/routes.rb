Rails.application.routes.draw do

  get 'user/events/current', to: 'user/events/current#attendees'


  # These don't seem to like namespacing much
  get 'user/events/current/:id/attendees' => 'user/events/current#attendees', as: :attendees_user_current_event
  get 'user/events/current/:id/favorites' => 'user/events/current#favorites', as: :favorites_user_current_event
  get 'user/events/current/:id/inbox' => 'user/events/current#inbox', as: :inbox_user_current_event
  get 'user/events/current/:id' => 'user/events/current#inbox', as: :user_current_event

  get 'user', to: 'user/events#index'
  namespace :user do
    resources :events, only: [:show, :index] do
      collection do
        get 'my_events'
        get 'join'
        get 'search'
      end
    end
  end
  get 'user/events' => 'user/events#index'

  get 'admin', to: 'admin/events#index'
  namespace :admin do
    resources :events, :places
  end

  root "user/events#index"
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
