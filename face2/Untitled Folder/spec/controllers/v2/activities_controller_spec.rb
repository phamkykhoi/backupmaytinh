require "rails_helper"

RSpec.describe V2::ActivitiesController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    context "when user receive activity of comment" do
      let!(:followership) do
        FactoryGirl.create :followership, followee: followee, follower: user
      end
      let!(:_post){FactoryGirl.create :post, user: user}
      let!(:json) do
        activity = _post.comments.create(content: "comment", user: followee)
          .activities.first
        {
          activities: [
            {
              user_profile_photo_url: activity.user.profile_photo.thumb_small.url,
              target_photo_url: activity.target_photo_url,
              body: activity.body,
              updated_at: activity.updated_at,
              type: activity.trackable_type,
              target_id: activity.target_id,
              destination_id: activity.destination_id
            }
          ],
          total_count: 1
         }.to_json
      end
      let(:followee){FactoryGirl.create :user}

      before{xhr :get, :index}

      it {expect(response.body).to eq json}
    end

    context "when user recevive activity of bulletin" do
      let(:bulletin){FactoryGirl.create :bulletin}
      let!(:json) do
        activity = bulletin.activities.first
        {
          activities: [
            {
              user_profile_photo_url: nil,
              target_photo_url: nil,
              body: activity.body,
              updated_at: activity.updated_at,
              type: activity.trackable_type,
              target_id: activity.target_id,
              destination_id: activity.destination_id
            }
          ],
          total_count: 1
         }.to_json
      end

      before{xhr :get, :index}

      it {expect(response.body).to eq json}
    end
  end
end
