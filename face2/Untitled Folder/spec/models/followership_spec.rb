require "rails_helper"

RSpec.describe Followership, type: :model do
  let(:followership){FactoryGirl.create :followership}

  describe "Validation" do
    subject{followership}

    [:followee_id, :follower_id].each do |attribute|
      context "when #{attribute} is nil" do
        before do
          followership.send "#{attribute}=", nil
        end

        it {is_expected.to be_invalid}
      end
    end

    context "when followee and follower is same" do
      before do
        followership.followee_id = 1
        followership.follower_id = 1
      end

      it {is_expected.to be_invalid}
    end
  end
end
