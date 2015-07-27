class V2::LocationsController < ApplicationController
  def show
    @location = GeoIP.new(Settings.geoip_location).city request.remote_ip
  end
end
