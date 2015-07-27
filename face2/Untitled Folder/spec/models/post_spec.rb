require "rails_helper"

RSpec.describe Post, type: :model do
  let(:post){FactoryGirl.create :post}

  describe "Validation" do
    subject{post}

    [:user_id, :m_genre_id].each do |attribute|
      context "when #{attribute} is nil" do
        before {post.send "#{attribute}=", nil}

        it {is_expected.to be_invalid}
      end
    end

    context "when from is web and there is not photo" do
      before do
        post.from = "web"
        post.photos.destroy_all
      end

      it {is_expected.to be_invalid}
    end
  end
end
