# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    put :delete_files
    resources :answers, shallow: true do
      member do
        put :delete_files
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
