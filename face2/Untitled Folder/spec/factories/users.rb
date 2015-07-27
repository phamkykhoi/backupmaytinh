FactoryGirl.define do
  factory :user do
    name "MyString"
    birthday{Date.today}
    facebook_token "xxxxx"
    profile_photo{fixture_file_upload("spec/files/test_image1.jpg", "image/jpg")}
  end
end
