Rails.application.routes.draw do
    root to: 'tasks#index'

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'signup', to: 'users#new'
    resources :tasks
    
    #resources :users, only: [:index, :show, :new, :create]
    #user情報を出すindexやshowは現時点で不要のためコメントアウト↑
    resources :users, only: [:new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
