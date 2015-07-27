require "rails_helper"

RSpec.describe Android, type: :model do
  describe "Validation" do
    subject{android}

    let(:android){FactoryGirl.create :android}

      context "when type is nil" do
        before{android.registration_id = nil}

        it {is_expected.to be_invalid}
      end
  end
end
