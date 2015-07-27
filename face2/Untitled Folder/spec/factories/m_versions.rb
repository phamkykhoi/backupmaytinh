FactoryGirl.define do
  factory :m_version, class: "M::Version" do
    required_ios "1.0.0"
    required_android "1.0.0"
    latest_ios "2.0.0"
    latest_android "2.0.0"
  end
end
