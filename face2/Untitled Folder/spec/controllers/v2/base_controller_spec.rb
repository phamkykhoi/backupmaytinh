require "rails_helper"

RSpec.describe V2::BaseController, type: :controller do
  subject{response}

  describe "check_api_token" do
    controller do
      skip_before_action :authenticate
      skip_before_action :set_content_type_of_response
      before_action :check_api_token

      def check_api_token_test
        render text: "response"
      end
    end

    before do
      routes.draw {get "check_api_token_test" => "v2/base#check_api_token_test"}
    end

    context "when X-API-TOKEN is fine" do
      before do
        request.env["HTTP_X_API_TOKEN"] = Rails.application.secrets.api_token
        get :check_api_token_test
      end

      it {is_expected.to be_success}
    end

    context "when X_API-TOKEN is not fine" do
      before do
        get :check_api_token_test
      end

      it {expect(subject.code).to eq "401"}
    end
  end

  describe "authenticate" do
    let(:user){FactoryGirl.create :user}

    controller do
      skip_before_action :set_content_type_of_response
      before_action :authenticate

      def authenticate_test
        render text: "response"
      end
    end

    before do
      routes.draw {get "authenticate_test" => "v2/base#authenticate_test"}
    end

    context "when HTTP_AUTHORIZATION is fine" do
      before do
        request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
        get :authenticate_test
      end

      it {is_expected.to be_success}
    end

    context "when HTTP_AUTHORIZATION is not fine" do
      before do
        get :authenticate_test
      end

      it {expect(subject.code).to eq "401"}
    end
  end
end
