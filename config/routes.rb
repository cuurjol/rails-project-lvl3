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

      resources :categories, except: :show
    end

    resources :bulletins, except: :destroy do
      member do
        patch :moderate
        patch :archive
        patch :draft
      end
    end

    get :profile, to: 'profiles#show'
    post '/bulletins/:bulletin_id/bulletin_contacts', to: 'bulletin_contacts#create', as: :bulletin_contacts

    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    delete 'auth/sign_out', to: 'auth#destroy', as: :sign_out
  end
end
