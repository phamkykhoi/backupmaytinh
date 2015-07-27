include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :photo do
    post{FactoryGirl.create :post}
    description "description"
    content{fixture_file_upload("spec/files/test_image1.jpg", "image/jpg")}
    width_ratio 2
    height_ratio 4
    main false
  end
end
