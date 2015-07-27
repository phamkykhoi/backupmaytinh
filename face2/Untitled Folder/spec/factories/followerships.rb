FactoryGirl.define do
  factory :followership do
    follower{FactoryGirl.create :user}
    followee{FactoryGirl.create :user}
  end
end
