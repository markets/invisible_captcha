Dummy::Application.routes.draw do
  resources :topics, only: [:new, :create]
end
