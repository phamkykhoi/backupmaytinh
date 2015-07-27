require "rails_helper"

RSpec.describe M::Version, type: :model do
  describe "Validation" do
    subject{m_version}

    let(:m_version){FactoryGirl.create :m_version}

    [:required_ios, :required_android, :latest_ios,
     :latest_android].each do |attribute|
     context "when #{attribute} is invalid format" do
       before do
         m_version.send "#{attribute}=", "000000"
       end

       it {is_expected.to be_invalid}
     end
    end
  end

  describe "::check" do
    subject{M::Version.check version, device}

    before do
      FactoryGirl.create :m_version,
        required_ios: "2.0.0" ,
        latest_ios: "3.0.0",
        required_android: "2.0.0",
        latest_android: "3.0.0"
    end

    context "when argument is invalid" do
      let(:version){"100"}
      let(:device){"ios"}

      it {is_expected.to eq nil}
    end

    M::Version::DEVECES.each do |_device|
      context "when #{_device}'s 'version is less than required" do
        let(:version){"1.0.0"}
        let(:device){_device}

        it {is_expected.to eq M::Version::STATUS[:requiring_update]}
      end

      context "when #{_device}'s 'version is more than required and lowwer than latest" do
        let(:version){"2.1.0"}
        let(:device){_device}

        it {is_expected.to eq M::Version::STATUS[:recommending_update]}
      end

      context "when #{_device}'s 'version is latest" do
        let(:version){"3.0.0"}
        let(:device){_device}

        it {is_expected.to eq M::Version::STATUS[:latest]}
      end
    end
  end
end
