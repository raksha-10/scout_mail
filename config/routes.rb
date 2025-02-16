Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Ensure that Devise knows this route belongs to the :user model
  devise_scope :user do
    post 'verify_otp', to: 'users/registrations#verify'  # Move inside devise_scope
    post 'verify_account', to: 'users/registrations#verify_account'  # Move inside devise_scope

  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:update]
      get 'users/show', to: 'users#show_current_user'
      post 'users/toggle_user_status', to: 'users#toggle_user_status'
      get 'users/invited_users', to: 'users#invited_users'
      post 'users/invite_user', to: 'users#invite_user'
      post 'users/resend_invite', to: 'users#resend_invite'
      get 'users/accept_invitation', to: 'users#accept_invitation'
      post 'users/otp_password_set', to: 'users#otp_password_set'
      get 'organisations/organisation_types', to: 'organisations#organisation_types'
      resources :organisations, only: [:show, :update]
      resources :roles, only: [:index]
    end
  end
end
