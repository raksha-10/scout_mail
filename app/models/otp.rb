class Otp < ApplicationRecord
  belongs_to :user

  before_create :set_expiry

  private

  def set_expiry
    self.expires_at = 10.minutes.from_now
  end
end
