require "rails_helper"

RSpec.describe Photo, type: :model do
  let(:photo){FactoryGirl.create :photo}

  describe "Validation" do
    subject{photo}

    context "when content is empty" do
      before{photo.remove_content!}

      it {is_expected.to be_invalid}
    end
  end

  xdescribe "#temporally_photo_url=" do
    let(:temporally_photo_url) do
      "#{Rails.root}/spec/files/test_image1.jpg"
    end
    before do
      photo.temporally_photo_url = temporally_photo_url
    end

    it {expect(photo.content).not_to eq nil}

    it do
      photo_size = FastImage.size temporally_photo_url
      greatest_common_divisor = photo_size[0].gcd photo_size[1]
      expect(photo.width_ratio).to eq (photo_size[0] / greatest_common_divisor)
    end

    it do
      photo_size = FastImage.size temporally_photo_url
      greatest_common_divisor = photo_size[0].gcd photo_size[1]
      expect(photo.height_ratio).to eq (photo_size[1] / greatest_common_divisor)
    end
  end
end
