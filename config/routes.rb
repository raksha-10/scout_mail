# Rails.application.routes.draw do
#   namespace :api do
#     namespace :v1 do
#       resources :users, only: [:update] do
#         resources :organisations, only: [:index, :create]
#       end
#       post 'users/invite', to: 'users#invite_user'
#       post 'users/accept_invitation', to: 'users#accept_invitation'
#     end
#   end

#   devise_for :users, path: '', path_names: {
#     sign_in: 'login',
#     sign_out: 'logout',
#     registration: 'signup'
#   },
#   controllers: {
#     sessions: 'users/sessions',
#     registrations: 'users/registrations'
#   }
#   get "up" => "rails/health#show", as: :rails_health_check

# end
# Rails.application.routes.draw do
#   namespace :api do
#     namespace :v1 do
#       post 'signup', to: 'auth#signup'
#       post 'verify_otp', to: 'auth#verify_otp'
#       post 'login', to: 'auth#login'
#     end
#   end
#   get "up" => "rails/health#show", as: :rails_health_check
# end


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
    post 'resend_otp', to: 'users/registrations#resend_otp'  # Move inside devise_scope

  end
end
