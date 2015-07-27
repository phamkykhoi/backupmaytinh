require "rails_helper"

RSpec.describe V2::LocationsController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET show" do
    let!(:json) do
      {
        location: {
          country_code2: "VN",
          country_code3: "VNM",
          country_name: "Vietnam",
          region_name: "44",
          city_name: "Hanoi",
        }
      }.to_json
    end

    before  do
      request.env["REMOTE_ADDR"] = "113.190.240.135"
      xhr :get, :show
    end

    it {expect(response.body).to eq json}
  end
end
