class UserMailer < ApplicationMailer
    default from: 'harshitshreshthi8@gmail.com' # Change to your sender email
  
    def send_otp(user, otp)
      @user = user
      @otp = otp
      mail(to: @user.email, subject: 'Your OTP Code')
    end


    def send_activation_email(user)
      @user = user
      @activation_token = @user.activation_token
      @activation_url = "http://localhost:3001/api/v1/users/accept_invitation?token=#{@activation_token}"
  
      mail(to: @user.email, subject: 'Activate Your Account')
    end
  end
