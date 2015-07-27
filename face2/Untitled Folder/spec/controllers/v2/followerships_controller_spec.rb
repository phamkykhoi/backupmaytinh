require "rails_helper"

RSpec.describe V2::FollowershipsController, type: :controller do
  render_views

  let(:followee){FactoryGirl.create :user}
  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    let(:follower){FactoryGirl.create :user}
    let!(:followership) do
      FactoryGirl.create :followership, follower: follower, followee: followee
    end

    context "Get follower" do
      let!(:followee_by_current_user) do
        followerships_following_current_user = Followership.where(follower_id: user.id)
          followership.is_included followerships_following_current_user, "follower_id_eq"
      end

      let!(:json) do
        {
          followerships: [{
            id: followership.id,
            follower_id: followership.follower.id,
            follower_name: followership.follower.name,
            follower_profile_photo_url: followership.follower.profile_photo
              .thumb_small.try(:url),
            followee_id: followership.followee.id,
            followee_name: followership.followee.name,
            followee_profile_photo_url: followership.followee.profile_photo
              .thumb_small.try(:url),
            following_followership_id: followee_by_current_user.present? ? follower_by.id : "",
            following_followership_status: followee_by_current_user.present?
          }]
        }.to_json
      end

      before do
        xhr :get, :index, q: {follower_id_eq: follower.id}
      end

      it {expect(response.body).to eq json}
    end

    context "Get followee" do
      let!(:followee_by_current_user) do
        followerships_following_current_user = Followership.where(follower_id: user.id)
        followership.is_included followerships_following_current_user, "followee_id_eq"
      end

      let!(:json) do
        {
          followerships: [{
            id: followership.id,
            follower_id: followership.follower.id,
            follower_name: followership.follower.name,
            follower_profile_photo_url: followership.follower.profile_photo
              .thumb_small.try(:url),
            followee_id: followership.followee.id,
            followee_name: followership.followee.name,
            followee_profile_photo_url: followership.followee.profile_photo
              .thumb_small.try(:url),
            following_followership_id: followee_by_current_user.present? ? follower_by.id : "",
            following_followership_status: followee_by_current_user.present?
          }]
        }.to_json
      end

      before do
        xhr :get, :index, q: {followee_id_eq: followee.id}
      end

      it {expect(response.body).to eq json}
    end
  end

  describe "POST create" do
    describe "Check response" do
      subject{response.body}

      let(:id){1}
      let(:json){{followership: {id: id}}.to_json}

      before do
        allow_any_instance_of(Supportership).to receive(:id).and_return id
        xhr :post, :create, followership: {followee_id: followee.id}
      end

      it {is_expected.to eq json}
    end

    describe "Check increaseing" do
      it "is expected to increase count" do
        expect do
          xhr :post, :create, followership: {followee_id: followee.id}
        end.to change(Followership, :count).by 1
      end
    end
  end

  describe "POST #destroy" do
    it do
      followership = FactoryGirl.create :followership
      expect {
        xhr :delete, :destroy, id: followership.id
      }.to change(Followership, :count).by -1
     end
  end
end
