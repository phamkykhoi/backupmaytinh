require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:comment){FactoryGirl.create :comment}

  describe "Validation" do
    subject{comment}

    [:post_id, :user_id, :content].each do |attribute|
      context "when #{attribute} is nil" do
        before{comment.send "#{attribute}=", nil}

        it {is_expected.to be_invalid}
      end
    end
  end
end
