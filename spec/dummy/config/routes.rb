Rails.application.routes.draw do
  resources :topics, only: [:new, :create, :update] do
    member do
      post :publish
    end
  end

  root to: 'topics#new'
end
