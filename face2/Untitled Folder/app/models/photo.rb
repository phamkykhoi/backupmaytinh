class Photo < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:description, :content, :post_id, :main,
    :width_ratio, :height_ratio, :temporally_photo_url]

  attr_accessor :temporally_photo_url

  acts_as_paranoid

  belongs_to :post

  scope :with_main, ->{find_by main: true}
  scope :without_main, ->{where main: false}

  mount_uploader :content, PhotoUploader
  skip_callback :commit, :after, :remove_content!

  paginates_per 25

  validates :content, :width_ratio, :height_ratio, presence: true

  before_create :set_main

  def background_color
    %w(#e3d9cf #e3e3cf #d9e3cf #cfe3cf #cfe3d9 #cfe3e3 #cfd9e3 #cfcfe3
      #d9cfe3 #e3cfe3 #e3cfd9 #e3cfcf).sample
  end

  def temporally_photo_url= value
    return if value.blank?

    @temporally_photo_url = value
    url = "public/#{value}"
    photo_size = FastImage.size url
    greatest_common_divisor = photo_size[0].gcd photo_size[1]

    self.content = File.open url
    self.width_ratio = (photo_size[0] / greatest_common_divisor)
    self.height_ratio = (photo_size[1] / greatest_common_divisor)
  end

  private
  def set_main
    self.main = false unless self.main
    return
  end
end
