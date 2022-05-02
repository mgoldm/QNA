# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      member do
        put :update_best
      end
    end
  end

  post :votes, to: 'votes#vote'
  resources :comments, only: :create, shallow: true
  resources :rewards, only: :index, shallow: true
  resources :files, only: :destroy, shallow: true
  resources :links, only: :destroy, shallow: true

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
