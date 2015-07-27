class M::Version < ActiveRecord::Base
  STATUS = {
    latest: 0,
    recommending_update: 1,
    requiring_update: 2
  }
  FORMAT_REGEX = /\A\d+\.\d+\.\d+\z/
  DEVECES = ["ios", "android"]

  validates :required_ios, :required_android, :latest_ios, :latest_android,
    format: {with: FORMAT_REGEX}

  class << self
    def check version, device
      unless FORMAT_REGEX.match(version) && DEVECES.include?(device)
        return nil
      end

      if convert(version) < convert(send("required_#{device}"))
        STATUS[:requiring_update]
      elsif convert(version) < convert(send("latest_#{device}"))
        STATUS[:recommending_update]
      else
        STATUS[:latest]
      end
    end

    private
    def required_ios
      @@required_ios ||= M::Version.last.required_ios
    end

    def required_android
      @@required_android ||= M::Version.last.required_android
    end

    def latest_ios
      @@latest_ios ||= M::Version.last.latest_ios
    end

    def latest_android
      @@latest_android ||= M::Version.last.latest_android
    end

    def convert version
      version.split(".").map{|num| sprintf "%03d", num}.join
    end
  end
end
