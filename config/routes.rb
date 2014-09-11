Rails.application.routes.draw do
  resources :questions, except: [:index] do
    resources :answers, only: [:create, :update, :destroy] do
      member do
        post 'accept'
        post 'unaccept'
      end
    end
  end

  devise_for :users
  get 'static_pages/home'
  root 'static_pages#home'
end
