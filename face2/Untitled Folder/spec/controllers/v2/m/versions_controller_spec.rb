require "rails_helper"

describe V2::M::VersionsController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET show" do
    let(:version){FactoryGirl.create :m_version}

    context "when params is valid" do
      subject{response.body}

      let(:status){1}
      let(:json) do
        {
          version: {
            status: status
          }
        }.to_json
      end

      before do
        allow(M::Version).to receive(:check).and_return status
        xhr :get, :show, {version: version.latest_ios, device: "ios"}
      end

      it {is_expected.to eq json}
    end

    context "when params is invalid" do
      subject{response.response_code}

      before do
        allow(M::Version).to receive(:check).and_return nil
        xhr :get, :show, {version: version.latest_ios, device: "ios"}
      end

      it {is_expected.to eq 400}
    end
  end
end
