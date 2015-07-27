module Admin::BulletinsHelper
  def scrape_headline content
   h1_block = content.slice /<h1>(.*)<\/h1>/
   strip_tags h1_block.gsub /<br\/?>/,"\s"
  end
end
