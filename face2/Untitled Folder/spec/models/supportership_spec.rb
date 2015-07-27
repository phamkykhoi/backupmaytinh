require "rails_helper"

RSpec.describe Supportership, type: :model do
  let(:supportership){FactoryGirl.create :supportership}

  describe "Validation" do
    subject{supportership}

    [:post_id, :supporter_id].each do |attribute|
      context "when #{attribute} is nil" do
        before do
          supportership.send "#{attribute}=", nil
        end

        it {is_expected.to be_invalid}
      end
    end
  end
end
