Rails.application.routes.draw do
  get 'user', to: 'user/events#index'
  get 'user/events', to: 'user/events#index'
  get 'user/events/current', to: 'user/events/current#attendees'
  namespace :user do
    resources :events, only: [:show, :index] do
      collection do
        get 'my_events'
        get 'join'
        get 'search'
      end

      member do
        get 'current/attendees' => 'users/events/current#attendees'
        get 'current/favorites' => 'users/events/current#favorites'
        get 'current/inbox' => 'users/events/current#inbox'
        get 'current' => 'users/events/current#attendees'
      end
    end
  end

  get 'admin', to: 'admin/events#index'
  namespace :admin do
    resources :events, :places
  end

  root "user/events#index"
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
