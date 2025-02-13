Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:update] do
        resources :organisations, only: [:index, :create]
      end
      post 'users/invite', to: 'users#invite_user'
      post 'users/accept_invitation', to: 'users#accept_invitation'
    end
  end

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get "up" => "rails/health#show", as: :rails_health_check

  # root "posts#index"
end
