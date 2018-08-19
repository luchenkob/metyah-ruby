Rails.application.routes.draw do

  namespace :user do
    resources :events, only: [:show, :index]
  end

  namespace :admin do
    resources :events, :places
  end

  root "user/events#index"
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
