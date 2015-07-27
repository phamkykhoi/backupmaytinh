class RequestToken < ActiveRecord::Base
  EXPIRE_AFTER_SECONDS = Settings.expire_after_seconds

  belongs_to :user

  before_create :generate_token

  def generate_token!
    generate_token
    save
  end

  private
  def generate_token
    self.content = loop do
      random_token = SecureRandom.urlsafe_base64 nil, false
      unless User.joins(:request_token)
        .where(request_tokens: {content: random_token}).exists?
        break random_token
      end
    end

    self.expires_at = Time.zone.now + EXPIRE_AFTER_SECONDS
  end
end
