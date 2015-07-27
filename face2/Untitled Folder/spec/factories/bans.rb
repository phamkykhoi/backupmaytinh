FactoryGirl.define do
  factory :ban do
    user{FactoryGirl.create :user}
    reportable_type{"Post"}
    reportable{FactoryGirl.create :post}
  end
end
