require "factual"

class FactualApi
  include Singleton

  Countries = ["places-us", "places-cn", "places-jp", "places-de", "places-it",
    "places-fr", "places-es", "places-gb", "places-br", "places-ca",
    "places-au", "places-kr", "places-pt", "places-tw", "places-ch",
    "places-no", "places-ru", "places-se", "places-at", "places-mx",
    "places-dk", "places-za", "places-in", "places-id", "places-fi",
    "places-nl", "places-be", "places-th", "places-ph", "places-sg",
    "places-ar", "places-hk", "places-ie", "places-pl", "places-tr",
    "places-nz", "places-my", "places-il", "places-cl", "places-co",
    "places-hu", "places-vn", "places-hr", "places-cz", "places-pr",
    "places-lu", "places-ve", "places-pe", "places-gr", "places-eg"]

  def initialize
    @client = Factual.new ENV["FACTUAL_KEY"], ENV["FACTUAL_SECRET"]
  end

  def client
    @client
  end

  class << self
    def search ip_address, query
      country_query = country_query ip_address
      cache_key = "#{country_query}:#{query}"
      Rails.cache.fetch(cache_key, expires_in: 1.day) do
        instance.client.table(country_query)
          .search(query).page(1, per: 20).rows
      end
    end

    private
    def country_query ip_address
      location = GeoIP.new(Settings.geoip_location).city ip_address
      if location
        _country_query = "places-#{location.country_code2.downcase}"
        if FactualApi::Countries.include? _country_query
          _country_query
        else
          "places"
        end
      else
        "places"
      end
    end
  end
end
