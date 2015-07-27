module Admin::PlayersHelper
  def remove_invalid_byte str
    return nil unless str
    str.encode("UTF-16BE", "UTF-8",
      invalid: :replace, undef: :replace, replace: "?").encode "UTF-8"
  end

  def link_to_facebook facebook_id
    facebook_link = "https://facebook.com/#{facebook_id}"
    link_to "Facebook", facebook_link
  end

  def link_to_twitter twitter_id
    twitter_link = "https://twitter.com/intent/user?user_id=#{twitter_id}"
    link_to "Twitter", twitter_link
  end

  def link_to_google google_id
    google_link = "https://plus.google.com/#{google_id}"
    link_to "Google", google_link
  end
end
