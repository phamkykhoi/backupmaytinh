FactoryGirl.define do
  factory :comment do
    content "MyText"
    post{FactoryGirl.create :post}
    user{FactoryGirl.create :user}
  end
end
