require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let(:remember_token){"remember_token"}
  let!(:user) do
    FactoryGirl.create :user, remember_token: User.encrypt(remember_token)
  end

  before do
    request.cookies[:remember_token] = remember_token
  end

  describe "GET new" do
    subject{response}

    before{get :new}

    it {is_expected.to render_template :new}
  end

  xdescribe "POST create" do
    let(:m_genre){FactoryGirl.create :m_genre}
    let(:attributes) do
      {
        post: {
          m_genre_id: m_genre.id,
          tag_ids: ["[]"],
          photos_attributes: {
           "0" => {temporally_photo_url: "spec/files/test_image1.jpg"}
          }
        }
      }
    end

    describe "Check post count after create" do
      context "when creating is success" do
        it do
          expect{post :create, attributes}
            .to change(Post, :count).by 1
        end
      end

      context "when creating is failure" do
        before do
          allow_any_instance_of(Post).to receive(:save).and_return false
        end

        it do
          expect{post :create, attributes}
            .to change(Post, :count).by 0
        end
      end
    end


    describe "Check rendering view" do
      subject{response}

      before do
        post :create, attributes
      end

      context "when creating is success" do
        it {is_expected.to redirect_to new_post_path}
      end
    end
  end
end
