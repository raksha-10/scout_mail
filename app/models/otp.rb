class Otp < ApplicationRecord
  belongs_to :user

  before_create :set_expiry

  def self.find_valid_otp(user_id, code)
    where(user_id: user_id, code: code)
      .where("expires_at > ?", Time.current)
      .order(:created_at)
      .first
  end

  private

  def set_expiry
    self.expires_at = 10.minutes.from_now
  end
end
