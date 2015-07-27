namespace :aggregate do
  desc "Aggregate weekly ranking"
  task weekly_ranking: :environment do
    previous_weekly_ranking_id = WeeklyRanking.last.try :id

    weekly_ranking = WeeklyRanking.create m_ranking_type_id: 2

    target_week = Time.zone.now - 1.weeks
    users = User
      .select("COUNT(supporterships.supportee_id) as supportings_count_at_last_week, users.*")
      .joins(posts: :supporterships_at_last_week).group(:supportee_id)
      .where("supporterships.updated_at" => target_week.beginning_of_week..target_week.end_of_week)
      .order("supportings_count_at_last_week DESC")
      .limit Settings.returning_ranking_subtotal_num
    ranker_photos = []
    top_ranker_name = nil

    users.each.with_index 1 do |user, i|
      if i <= Settings.ranker_photos_num
        ranker_photos << user.profile_photo.url
      end

      if i == 1
        top_ranker_name = user.name
      end

      supporterships = Supportership.ransack(supportee_id_eq: user.id,
        last_week: true, supporter_ranking: true).result

      supporter_photos = supporterships.take(Settings.supporter_photos_num)
        .each_with_object [] do |supportership, photos|
        photos << (supportership.try(:supporter).try(:profile_photo)
          .try(:thumb_small).try :url)
      end
      weekly_ranking.ranking_subtotals.create rank: i, user_id: user.id,
        supportings_count: user.supportings_count_at_last_week,
        supporter_photos: supporter_photos
    end

    weekly_ranking.update ranker_photos: ranker_photos,
      top_ranker_name: top_ranker_name

    FileUtils.rm_f "#{Settings.page_cache_directory}/v2/rankings/#{previous_weekly_ranking_id}.json"
  end
end
