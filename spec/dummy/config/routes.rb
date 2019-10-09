# frozen_string_literal: true

Rails.application.routes.draw do
  resources :topics do
    post :publish, on: :member
    post :copy, on: :collection
  end

  root to: 'topics#new'
end
