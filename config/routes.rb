Rails.application.routes.draw do
  constraints(-> (request) { request.headers['User-Agent'] !~ FIREFOX_BROWSER_REGEX}) do
    controller :sessions do
      get  'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
    end

    get 'sessions/create'
    get 'sessions/destroy'

    get '/my-orders', to: 'users#orders'
    get '/my-items', to: 'users#line_items'

    resources :users

    resources :products, path: '/books' do
      get :who_bought, on: :member
    end

    resources :support_requests, only: [ :index, :update ]

    resources :category do
      resources :products, path: '/books', as: 'books', constraints: { category_id: DIGIT_REGEX }
      resources :products, path: '/books', as: 'books', to: redirect('/')
    end

    namespace :admin do
      get 'reports', to: 'reports#index'
      get 'categories', to: 'categories#index'
    end

    scope '(:locale)' do
      resources :orders
      resources :line_items
      resources :carts
      root 'store#index', as: 'store_index', via: :all
    end
  end
  root "store#index"
end
