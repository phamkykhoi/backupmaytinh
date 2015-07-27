require "rails_helper"

describe V2::SessionsController, type: :controller do
  subject{response}

  render_views

  let(:user){FactoryGirl.create :user}

  before do
    request.env["HTTP_X_API_TOKEN"] = Rails.application.secrets.api_token
  end

  describe "POST #create" do
    context "when there is login_id" do
      before do
        expect(User)
          .to receive(:find_by).with({login_id: user.login_id}).and_return user
        xhr :post, :create, user: {login_id: user.login_id}
      end

      it {is_expected.to be_success}
    end

    context "when there is not login_id" do
      before do
        expect(User)
          .to receive(:find_by).with({login_id: user.login_id}).and_return false
        xhr :post, :create, user: {login_id: user.login_id}
      end

      it {expect(subject.code).to eq "400"}
    end

    context "when user don't have request_token" do
      before do
        allow_any_instance_of(User)
          .to receive_message_chain(:request_token, :content)
          .and_return nil
        xhr :post, :create, user: {login_id: user.login_id}
      end
      it {expect(subject.code).to eq "403"}
    end
  end

  describe "POST login" do
    let(:password){"12345678"}
    let!(:user) do
      FactoryGirl.create :user, email: "example@example.com", password: password
    end

    context "when user success login" do
      let(:registration_id){"xxxxxxxx"}
      let(:json) do
        {
          user: {
            id: user.id,
            login_id: user.login_id,
            request_token: user.request_token.reload.content,
            ticket_id: user.ticket.id
          }
        }.to_json
      end

      before do
        xhr :post, :login, user: {
          email: user.email,
          password: user.password,
          oss_attributes: [
            {registration_id: registration_id, type: "Android"}
          ]
        }
      end

      it {expect(assigns :user).to eq user}
      it {is_expected.to be_success}
      it {expect(subject.body).to eq json}
      it do
        expect(user.reload.androids.pluck :registration_id)
          .to include registration_id
      end
    end

    context "when user fail login" do
      before do
        xhr :post, :login, user: {email: user.email, password: "bar"}
      end

      it {expect(subject.code).to eq "400"}
    end
  end

  describe "POST logout" do
    before do
      request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
    end

    context "when loging_id is valid" do
      let(:registration_id){"xxxxxxxx"}
      before do
        user.androids.create registration_id: registration_id
        xhr :post, :logout, user: {
          login_id: user.login_id,
          oss_attributes: [
            {registration_id: registration_id, type: "Android"}
          ]
        }
      end

      it {is_expected.to be_success}
      it {expect(user.reload.request_token.content).to eq nil}
      it do
        expect(user.reload.androids.pluck :registration_id)
          .not_to include registration_id
      end
    end

    context "when loging_id is invalid" do
      before do
        xhr :post, :logout, user: {login_id: "invalid_login_id"}
      end

      it {expect(subject.code).to eq "400"}
    end
  end
end
