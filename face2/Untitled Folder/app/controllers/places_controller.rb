class PlacesController < BaseController
  def index
    if params[:ll]
      begin
        @places = FoursquareApi.instance.client.search_venues(
          ll: params[:ll],
          query: params[:query]
        )
      rescue
        @places = {"venues" => []}
      end
      render :foursquare
    else
      begin
        @places = FactualApi.search request.remote_ip, params[:query]
      rescue
        @places = []
      end
      render :factual
    end
  end
end
