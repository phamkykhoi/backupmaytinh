require "rails_helper"

describe V2::PhotosController, type: :controller do
  subject{response}

  render_views

  let(:photo){FactoryGirl.create :photo}
  let(:user){FactoryGirl.create :user}

  before  do
    request.env["HTTP_AUTHORIZATION"] = "Token token=#{user.request_token.content}"
  end

  describe "POST create" do
    let!(:attributes) do
      {
        description: photo.description,
        content: fixture_file_upload("spec/files/test_image1.jpg", "image/jpg"),
        width_ratio: photo.width_ratio,
        height_ratio: photo.height_ratio,
        main: photo.main
      }
    end

    it "is expected to increase count" do
      expect do
        xhr :post, :create, photo: attributes
      end.to change(Photo, :count).by 1
    end

    it "is expected to be success" do
      xhr :post, :create, photo: attributes
      is_expected.to be_success
    end
  end
end
