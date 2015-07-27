namespace :migrate do
  desc "Destroy activities and activity_inbox error"
  task delete_activity: :environment do
    %w[Followership Comment Supportership Bulletin Post].each do |item|
      activities = Activity.joins("LEFT OUTER JOIN #{item.downcase
        .pluralize} on activities.trackable_id = #{item.downcase.pluralize}.id")
        .where(trackable_type: item, "#{item.downcase.pluralize}.id" => nil)
      activities.find_each do |activity|
        activity.destroy
      end
    end
  end
end