Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'pages#home'
  mount GoodJob::Engine => 'good_job'

  devise_for :users
  resources :merchants
  resources :transactions, only: [:index, :new, :create],
                           path_names: { new: 'new/:transaction_type', create: 'new/:transaction_type' },
                           constraints: { transaction_type: %r{(authorize|charge|refund|reversal)} }
  get 'pages/home'

  namespace :api do
    post 'transactions/:transaction_type', to: 'transactions#create',
                                           constraints: { transaction_type: %r{(authorize|charge|refund|reversal)} }
  end

  match '*unmatched', to: 'application#route_not_found', via: :all
end
