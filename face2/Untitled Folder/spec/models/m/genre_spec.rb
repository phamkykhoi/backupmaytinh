require "rails_helper"

RSpec.describe M::Genre, type: :model do
  let(:m_genre){FactoryGirl.create :m_genre}

  describe "Validation" do
    [:name].each do |attribute|
      context "when #{attribute} is nil" do
        before {m_genre.send "#{attribute}=", nil}

        it {is_expected.to be_invalid}
      end
    end
  end
end
