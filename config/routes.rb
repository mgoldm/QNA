# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  use_doorkeeper
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
  resources :subscribers, only: [:create, :destroy], shallow: true

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers, only: %i[create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
