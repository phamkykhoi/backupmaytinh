require "rails_helper"

RSpec.describe V2::RankingHistoriesController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    subject{response.body}

    let(:json) do
      {
        ranking_histories: [
          {
            daily_1: user.ranking_history.daily_1,
            daily_2: user.ranking_history.daily_2,
            daily_3: user.ranking_history.daily_3,
            monthly_1_3: user.ranking_history.monthly_1_3,
            monthly_4_10: user.ranking_history.monthly_4_10,
            monthly_11_50: user.ranking_history.monthly_11_50
          }
        ]
      }.to_json
    end

    before do
      xhr :get, :index, q: {user_id_eq: user.id}
    end

    it {is_expected.to eq json}
  end
end
