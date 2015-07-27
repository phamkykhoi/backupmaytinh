module CarrierWave
  module RMagick
    def quality percentage
      manipulate! do |img|
        unless img.quality == percentage
	  img.write(current_path){self.quality = percentage}
        end
        img = yield(img) if block_given?
        img
      end
    end
  end
end
