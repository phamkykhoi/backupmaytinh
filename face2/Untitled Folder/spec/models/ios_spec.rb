require "rails_helper"

RSpec.describe Ios, type: :model do
  describe "Validation" do
    subject{ios}

    let(:ios){FactoryGirl.create :ios}

      context "when type is nil" do
        before{ios.device_token = nil}

        it {is_expected.to be_invalid}
      end
  end
end
