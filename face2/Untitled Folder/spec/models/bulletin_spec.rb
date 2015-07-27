require "rails_helper"

RSpec.describe Bulletin, type: :model do
  let(:bulletin){FactoryGirl.create :bulletin}

  describe "Validation" do
    subject{bulletin}

    [:content].each do |attribute|
      context "when #{attribute} is nil" do
        before{bulletin.send "#{attribute}=", nil}

        it {is_expected.to be_invalid}
      end
    end
  end
end
