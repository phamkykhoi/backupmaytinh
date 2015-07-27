require "rails_helper"

RSpec.describe Activity, type: :model do
  describe "#target_id" do
    subject{activity.target_id}

    context "when trackable_type is Post" do
      let(:post){FactoryGirl.create :post}
      let(:activity) do
        FactoryGirl.create :activity, trackable_type: Post.name,
          trackable_id: post.id
      end

      it {is_expected.to eq post.user_id}
    end

    context "when trackable_type is Supportership" do
      let(:supportership){FactoryGirl.create :supportership}
      let(:activity) do
        FactoryGirl.create :activity, trackable_type: Supportership.name,
          trackable_id: supportership.id
      end

      it {is_expected.to eq supportership.post_id}
    end

    context "when trackable_type is Comment" do
      let(:comment){FactoryGirl.create :comment}
      let(:activity) do
        FactoryGirl.create :activity, trackable_type: Comment.name,
          trackable_id: comment.id
      end

      it {is_expected.to eq comment.post_id}
    end

    context "when trackable_type is Followership" do
      let(:followership){FactoryGirl.create :followership}
      let(:activity) do
        FactoryGirl.create :activity, trackable_type: Followership.name,
          trackable_id: followership.id
      end

      it {is_expected.to eq followership.follower_id}
    end
  end
end
