require "rails_helper"

RSpec.describe Ban, type: :model do
  let(:ban){FactoryGirl.create :ban}

  describe "Valitaion" do
    subject{ban}

    [:user_id, :reportable_id, :reportable_type].each do |attribute|
      context "#{attribute} is nil" do
        before {ban.send "#{attribute}=", nil}

        it {is_expected.not_to be_valid}
      end
    end
  end
end
