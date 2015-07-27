FactoryGirl.define do
  factory :os do
    type "type"
  end

  factory :ios do
    device_token "device_token"
    type "Ios"
  end

  factory :android do
    registration_id "registration_id"
    type "Android"
  end
end
