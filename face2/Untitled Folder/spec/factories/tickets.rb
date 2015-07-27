FactoryGirl.define do
  factory :ticket do
    user{FactoryGirl.create :user}
  end
end
