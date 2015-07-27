require "rails_helper"

RSpec.describe V2::CamerasController, type: :controller do
  render_views

  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "GET index" do
    subject{response.body}

    let!(:camera_list) do
      FactoryGirl.create_list :camera, 5, name: "Camera name"
    end

    let(:cameras_json) do
      _cameras = Camera.all.each_with_object [] do |camera, cameras|
        cameras << {
          id: camera.id,
          name: camera.name,
        }
      end

    {cameras: _cameras}.to_json
    end

    before do
      xhr :get, :index
    end

    it {is_expected.to eq cameras_json}
  end
end
