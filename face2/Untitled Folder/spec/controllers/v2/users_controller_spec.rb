require "rails_helper"

describe V2::UsersController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  describe "GET index" do
    let(:user_new){FactoryGirl.create :user}
    let!(:post){FactoryGirl.create :post, user_id: user.id, updated_at: (Time.zone.now - 1.month),
      created_at: (Time.zone.now - 1.month)}
    let!(:json) do
      {
        users: [{
          id: post.user_id,
          name: user.name,
          user_profile_photo_url: user.profile_photo.thumb_small.try(:url),
          email: user.email,
          facebook_id: user.facebook_id,
          facebook_token: user.facebook_token,
        }]
      }.to_json
    end

    before do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
      xhr :get, :index, q: {suggesting_for_following: user_new.id}
    end

    it {expect(response.body).to eq json}
  end

  describe "PATCH #update" do
    subject{User.find(user.id).name}

    let(:fixed_attributes){{name: "bar", email: "bar@gmail.com"}}

    before do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
      xhr :patch, :update, id: user.id, user: fixed_attributes
    end

    it {is_expected.to eq fixed_attributes[:name]}
  end

  describe "POST #create" do
    before do
      request.env["HTTP_X_API_TOKEN"] = Rails.application.secrets.api_token
    end


    describe "Check response" do
      context "when params is valid" do
        let!(:json) do
          {
            user: {
              id: user.id,
              login_id: user.login_id,
              request_token: user.request_token.content,
              ticket_id: user.ticket.id
            }
          }.to_json
        end

        before do
          allow(User).to receive(:new).and_return user
          allow(User).to receive(:find_by).and_return nil
          allow_any_instance_of(User).to receive(:create_login_id)
            .and_return nil

          xhr :post, :create
        end

        it {expect(response.body).to eq json}
      end

      context "when params is invalid" do
        let(:user){FactoryGirl.build :user, email: "example@example.com"}
        let(:user_attributes) do
          {name: user.name, email: user.email,
            profile_photo: fixture_file_upload("spec/files/test_image1.jpg", "image/jpg")}
        end
        let(:json) do
          {
            user: {
              errors: user.errors.full_messages
            }
          }.to_json
        end

        before do
          user.valid?
          xhr :post, :create, user: user_attributes
        end

        it {expect(response.body).to eq json}
      end
    end

    context "when user create account first" do
      context "when params doesn't have os" do
        let(:user_attributes) do
          {name: "name", facebook_id: "112233",
            profile_photo: user.profile_photo}
        end

        it "is expected to increase user count" do
          expect do
            xhr :post, :create, user: user_attributes
          end.to change(User, :count).by 1
        end
      end

      [:ios, :android].each do |os|
        context "when params have #{os}" do
          let(:user_attributes) do
            token = (os == :ios ? :device_token : :registration_id)
            {
              name: "name",
              facebook_id: "112233",
              profile_photo: fixture_file_upload("spec/files/test_image1.jpg",
                "image/jpg"),
              oss_attributes: [{
                "#{token}" =>  "xxxxxxxxx",
                type: os.to_s.capitalize
              }]
            }
          end

          it "is expected to increase user count" do
            expect do
              xhr :post, :create, user: user_attributes
            end.to change(User, :count).by 1
          end

          it "is expected to increase os count" do
            expect do
              xhr :post, :create, user: user_attributes
            end.to change(os.to_s.capitalize.constantize, :count).by 1
          end
        end
      end
    end

    context "when user has account" do
      let!(:user){FactoryGirl.create :user, facebook_id: "AAAAAAAA"}

      it "is expected to increase user count" do
        expect do
          xhr :post, :create, user: {name: user.name,
            facebook_id: user.facebook_id,
            oss_attributes: [{
              device_token: "new_devise_toke",
              type: "Ios"
            }]
          }
        end.to change(User, :count).by 0
      end
    end
  end

  describe "GET #show" do
    subject{response.body}

    let(:current_user){FactoryGirl.create :user}
    let!(:monthly_ranking){FactoryGirl.create MonthlyRanking, m_ranking_type_id: 3}

    let(:user_json) do
      {
        user: {
          name: user.name,
          comment: user.comment,
          birthday: user.birthday,
          user_profile_photo_url: user.profile_photo.thumb_small.try(:url),
          facebook_id: user.facebook_id,
          facebook_token: user.facebook_token,
          email: user.email,
          followers_count: user.followers_count,
          followings_count: user.followings_count,
          supportings_count: user.supportings_count,
          posts_count: user.posts_count,
          latest_monthly_rank: user.latest_monthly_rank,
          followership_id: current_user.followership_id_with(user),
          ticket_recover_notice: user.ticket_recover_notice,
          no_login_notice: user.no_login_notice,
          followee_posts_notice: user.followee_posts_notice,
          supported_notice: user.supported_notice,
          commented_notice: user.commented_notice,
          followed_notice: user.followed_notice,
          bulletin_notice: user.bulletin_notice
        }
      }.to_json
    end

    before do
      monthly_ranking.ranking_subtotals.create user_id: user.id, rank: 21
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
      allow_any_instance_of(V2::UsersController)
        .to receive(:current_user).and_return current_user
      xhr :get, :show, {id: user.id}
    end

    it {is_expected.to eq user_json}
  end

  describe "POST password_reset" do
    subject{response}

    before do
      request.env["HTTP_X_API_TOKEN"] = Rails.application.secrets.api_token
      user.update email: "example@example.com", password: "12345678"
      xhr :post, :password_reset, {user: {email: email}}
    end


    context "when email exists" do
      let(:email){user.email}

      it {is_expected.to be_success}
    end

    context "when email not exists" do
      let(:email){nil}

      it {expect(subject.code).to eq "400"}
    end
  end

  describe "POST password change" do
    subject{response}

    before do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
      user.update email: "example@example.com", password: "12345678"
      xhr :patch, :update, id: user.id, user: {old_password: old_password, new_password: "87654321"}

    end
    context "when old_password correct" do
      let(:old_password){user.password}

      it {is_expected.to be_success}
    end

    context "when old_password incorrect" do
      let(:old_password){nil}

      it {expect(subject.code).to eq "400"}
    end
  end
end
