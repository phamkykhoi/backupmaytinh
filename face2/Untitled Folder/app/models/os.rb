class Os < ActiveRecord::Base
  validates :type, presence: true

  class << self
    def exists_same_as? os
      raise ArgumentError unless os.is_a?(Ios) || os.is_a?(Android)

      case os.type
      when "Ios"
        Ios.exists? device_token: os.device_token
      when "Android"
        Android.exists? registration_id: os.registration_id
      end
    end
  end
end
