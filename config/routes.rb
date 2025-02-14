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
      get 'organisations/organisation_types', to: 'organisations#organisation_types'
    end
  end
end
