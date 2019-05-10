Rails.application.routes.draw do
  root 'posts#index'
  resources :sessions, only: [:new, :create, :destroy]
  resources :users do
    member do
      get :edit_password
      patch :edit_pass
      patch :profile_file
    end
  end
  resources :posts do
    collection do
      post :confirm
    end
    member do
      patch :post_file
    end
  end
end
