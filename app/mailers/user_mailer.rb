class UserMailer < ApplicationMailer
    default from: 'harshitshreshthi8@gmail.com' # Change to your sender email
  
    def send_otp(user, otp)
      @user = user
      @otp = otp
      mail(to: @user.email, subject: 'Your OTP Code')
    end
  end
  