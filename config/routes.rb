Rails.application.routes.draw do

  namespace :user do
    resources :events, only: [:show, :index]
  end
  get 'user', to: 'user/events#index'

  namespace :admin do
    resources :events, :places
  end
  get 'admin', to: 'admin/events#index'

  root "user/events#index"
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
