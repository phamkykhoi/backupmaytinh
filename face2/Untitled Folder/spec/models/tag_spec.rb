require "rails_helper"

RSpec.describe Tag, type: :model do
  let(:tag){FactoryGirl.create :tag}

  describe "Validation" do
    subject{tag}

    before do
      tag.name = nil
    end

    it {is_expected.to be_invalid}
  end
end
