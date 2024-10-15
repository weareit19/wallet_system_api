Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
      resources :transactions, only: [ :create ]
      get "price/:symbol", to: "stocks#price", as: :stock_price
      get "stocks/prices", to: "stocks#prices"
      get "stocks/price_all", to: "stocks#price_all"
    end
  end
end
