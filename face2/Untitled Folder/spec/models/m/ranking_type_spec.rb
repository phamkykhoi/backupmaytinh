require "rails_helper"

RSpec.describe M::RankingType, type: :model do
  let(:m_ranking_type){FactoryGirl.create :m_ranking_type}

  describe "Validation" do
    [:name, :order].each do |attribute|
      context "when #{attribute} is nil" do
        before {m_ranking_type.send "#{attribute}=", nil}

        it {is_expected.to be_invalid}
      end
    end
  end
end
