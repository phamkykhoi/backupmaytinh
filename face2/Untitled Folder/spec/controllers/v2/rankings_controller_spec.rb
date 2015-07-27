require "rails_helper"

describe V2::RankingsController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    describe "Check instance variable" do
      before do
        2.upto 4 do |i|
          daily_ranking = FactoryGirl.create :daily_ranking
          daily_ranking.update(
            starts_displaying_at: (Time.zone.now - i.months).beginning_of_day,
            ends_displaying_at: (Time.zone.now - i.months).end_of_day
          )
        end

        FactoryGirl.create :daily_ranking
        FactoryGirl.create :weekly_ranking
        FactoryGirl.create :monthly_ranking
        FactoryGirl.create :genre_ranking
        xhr :get, :index
      end

      it {expect(assigns(:rankings).size).to eq 4}
    end

    describe "Check response" do
      let(:rankings){FactoryGirl.create_list :genre_ranking, 1}
      let!(:json) do
        {
          rankings: [
            id: rankings.first.id,
            name: rankings.first.m_ranking_type.name,
            range: rankings.first.range,
            top_ranker_name: rankings.first.top_ranker_name || "",
            ranker_photos: rankings.first.ranker_photos ? rankings.first
              .ranker_photos: Array.new
          ]
        }.to_json
      end

      before do
        xhr :get, :index
      end

      it do
        expect(response.body).to eq json
      end
    end
  end

  describe "GET show" do
    let(:daily_ranking){FactoryGirl.create :daily_ranking}
    let(:ranking_subtotals) do
      [
        FactoryGirl.create(:ranking_subtotal, {
          ranking_id: daily_ranking.id,
          user_id: user.id,
          rank: 1,
          supportings_count: 5,
          supporter_photos: ["xxx.jpg", "xxx.jpg"]
        })
      ]
    end
    let!(:json) do
      {
        ranking: {
          m_genre_id: daily_ranking.m_genre_id,
          range: daily_ranking.class::RANGE,
          ranking_subtotals: [{
            user_name: ranking_subtotals.first.user.name,
            user_profile_photo_url: ranking_subtotals.first.user.profile_photo
              .thumb_small.url,
            user_id: ranking_subtotals.first.user_id,
            rank: ranking_subtotals.first.rank,
            supportings_count: ranking_subtotals.first.supportings_count,
            supporter_photos: ranking_subtotals.first.supporter_photos
          }]}
      }.to_json
    end

    before do
      xhr :get, :show, id: daily_ranking.id
    end

    it {expect(response.body).to eq json}
  end
end
