module UserMailerUtils
    def self.send_otp_email(user, otp)
      UserMailer.send_otp(user, otp).deliver_later
    end
    def self.send_activation_email(user)
      user.generate_activation_token
      user.save 
      # Send activation email with the token
      UserMailer.send_activation_email(user).deliver_later
    end
  
end
  