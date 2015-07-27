FactoryGirl.define do
  factory :subtotal do
  end

  factory :ranking_subtotal do
    sequence(:rank){|n| n}
    supportings_count 1
    supporter_photos "MyText"
    type "RankingSubtotal"
    user{FactoryGirl.create :user}
  end

  factory :support_subtotal do
    supporters_count 1
    type "SupportSubtotal"
    user{FactoryGirl.create :user}
    targeted_at{Time.zone.now.beginning_of_month}
  end
end
