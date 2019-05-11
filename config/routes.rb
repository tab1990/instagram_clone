Rails.application.routes.draw do
  root 'posts#index'
  resources :sessions, only: [:new, :create, :destroy]
  resources :favorites,only:[:create,:destroy]
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
      get :favorite
    end
    member do
      patch :post_file
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
