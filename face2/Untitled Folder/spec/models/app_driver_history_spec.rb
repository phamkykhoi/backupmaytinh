require "rails_helper"

RSpec.describe AppDriverHistory, type: :model do
  let(:app_driver_history){FactoryGirl.create :app_driver_history}

  describe "Validation" do
    subject{app_driver_history}

    [:identifier, :achieve_id, :accepted_time, :campaign_id, :campaign_name,
      :advertisement_id, :advertisement_name, :point, :payment]
      .each do |attribute|
      context "when #{attribute} is nil" do
        before do
          app_driver_history.send "#{attribute}=", nil
        end

        it {is_expected.to be_invalid}
      end
    end
  end
end
