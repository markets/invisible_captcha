Rails.application.routes.draw do
  resources :topics do
    post :publish, on: :member

    post :rename, on: :collection
    post :categorize, on: :collection
    post :copy, on: :collection
  end

  root to: 'topics#new'
end
