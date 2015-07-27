class FoursquareApi
  include Singleton

  def initialize
    @client = Foursquare2::Client.new(
      client_id: ENV["FOURSQUARE_ID"],
      client_secret: ENV["FOURSQUARE_SECRET"],
      api_version: "20140806"
    )
  end

  def client
    @client
  end
end
