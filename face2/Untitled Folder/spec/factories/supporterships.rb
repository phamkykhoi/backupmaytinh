FactoryGirl.define do
  factory :supportership do
    supporter{FactoryGirl.create :user}
    supportee{FactoryGirl.create :user}
    post{FactoryGirl.create :post}
    m_genre{FactoryGirl.create :m_genre}
  end
end
