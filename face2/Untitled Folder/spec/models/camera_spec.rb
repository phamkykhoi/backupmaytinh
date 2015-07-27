require "rails_helper"

RSpec.describe Camera, type: :model do
  let(:camera){FactoryGirl.create :camera}

  describe "Validation" do
    subject{camera}

    before do
      camera.name = nil
    end

    it {is_expected.to be_invalid}
  end
end
