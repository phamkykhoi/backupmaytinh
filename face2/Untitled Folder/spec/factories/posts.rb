FactoryGirl.define do
  factory :post do
    user{FactoryGirl.create(:user)}
    m_genre{FactoryGirl.create(:m_genre)}
    photographer{FactoryGirl.create(:user)}
    camera{FactoryGirl.create(:camera)}
    location{"My string"}

    after :create do |post|
      post.photos << FactoryGirl.build(:photo, main: true,
        post: post)
      4.times do
        post.photos << FactoryGirl.build(:photo, main: false,
          post: post)
      end
    end
  end
end
