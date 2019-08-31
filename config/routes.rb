Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  namespace :api do
    namespace :v1 do
      post '/customers/create', to: 'customers#create'
      delete '/customers/destroy/:id', to: 'customers#destroy'
      put '/customers/update/:id', to: 'customers#update'
      get '/customers/status', to: 'customers#status'
      get '/customers/display/:id', to: 'customers#display'
      post '/accounts/create', to: 'accounts#create'
      delete '/accounts/destroy/:id', to: 'accounts#destroy'
      get '/accounts/search/:id', to: 'accounts#search'
      get '/accounts/status', to: 'accounts#status'
      post '/accountants/create', to: 'accountants#create'
      post '/accountants/withdraw', to: 'accountants#withdraw_money'
      post '/accountants/transfer', to: 'accountants#transfer_money'
      post '/accountants/deposit', to: 'accountants#deposit_money'
      get '/accountants/allTransactions', to: 'accountants#printStatementAllTransactions'
    end  
  end
end
