module UserMailerUtils
    def self.send_otp_email(user, otp)
      UserMailer.send_otp(user, otp).deliver_later
    end
  end
  