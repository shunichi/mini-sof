Rails.application.routes.draw do
  resources :questions do
    member do
      post 'upvote'
      post 'downvote'
    end
    collection do
      get 'page/:page', action: :index, as: 'paged'
      get 'tagged/:tag', action: :tagged, as: 'tagged'
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

  resources :tags, only: [:index]

  devise_for :users
  root 'questions#index'
end
