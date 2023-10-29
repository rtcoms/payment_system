Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'pages#home'
  mount GoodJob::Engine => 'good_job'

  devise_for :users
  resources :merchants
  resources :transactions, only: [:index]
  get 'pages/home'

  namespace :api do
    post 'transactions/:transaction_type', to: 'transactions#create',
                                           constraints: { transaction_type: %r{(authorize|charge|refund|reversal)} }
  end

  match '*unmatched', to: 'application#route_not_found', via: :all
end
