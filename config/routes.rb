# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
    root 'bulletins#index'

    namespace :admin do
      resource :session, only: %i[new create]

      resources :bulletins, only: %i[index destroy] do
        member do
          patch :publish
          patch :reject
          patch :archive
        end
      end

      resources :categories, only: %i[index new create edit update destroy]
      resources :users, only: %i[index edit update destroy]
    end

    resources :bulletins, only: %i[index show new create edit update] do
      scope module: :bulletins do
        resources :contacts, only: :create
      end

      member do
        patch :moderate
        patch :archive
        patch :draft
      end
    end

    resource :profile, only: :show

    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    delete 'auth/sign_out', to: 'auth#destroy', as: :sign_out
  end
end
