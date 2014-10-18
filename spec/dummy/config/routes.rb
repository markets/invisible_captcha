Dummy::Application.routes.draw do
  resources :topics, only: [:new, :create, :update]

  root to: 'topics#new'
end
