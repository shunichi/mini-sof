Rails.application.routes.draw do
  resources :questions do
    member do
      post 'upvote'
      post 'downvote'
    end
    resources :answers, only: [:create, :update, :destroy] do
      member do
        post 'accept'
        post 'unaccept'
        post 'upvote'
        post 'downvote'
      end
    end
  end

  devise_for :users
  root 'questions#index'
end
