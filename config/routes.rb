Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'pages#home'
  mount GoodJob::Engine => 'good_job'

  devise_for :users
  resources :merchants
  resources :transactions, only: [:index, :new, :create], path_names: {new: 'new/:transaction_type', create: 'new/:transaction_type' }
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    post 'transactions/:transaction_type', to: 'transactions#create'
  end
end
