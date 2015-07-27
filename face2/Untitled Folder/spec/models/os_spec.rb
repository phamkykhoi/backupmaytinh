require "rails_helper"

RSpec.describe Os, type: :model do
  describe "Validation" do
    subject{os}

    let(:os){FactoryGirl.create :os}

      context "when type is nil" do
        before{os.type = nil}

        it {is_expected.to be_invalid}
      end
  end

  describe "::exists_same_as?" do
    subject{Os.exists_same_as? argument}

    context "when argument is not Os" do
      let(:argument){"argument"}

      it {expect{subject}.to raise_exception}
    end

    context "when argument is Os" do
      context "when there is same record" do
        let(:argument){FactoryGirl.build :ios}

        before{FactoryGirl.create :ios}

        it {is_expected.to eq true}
      end

      context "when there is not same record" do
        let(:argument){FactoryGirl.build :ios}

        before{FactoryGirl.create :android}

        it {is_expected.to eq false}
      end
    end
  end
end
