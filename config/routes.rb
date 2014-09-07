Rails.application.routes.draw do
  resources :questions, except: [:index] do
    resources :answers, only: [:create, :update, :destroy]
  end

  devise_for :users
  get 'static_pages/home'
  root 'static_pages#home'
end
