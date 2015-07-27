namespace :aggregate do
  desc "Aggregate monthly ranking"
  task monthly_ranking: :environment do
    previous_monthly_ranking_id = MonthlyRanking.last.try :id

    monthly_ranking = MonthlyRanking.create m_ranking_type_id: 3

    target_month = Time.zone.now - 1.months
    users = User
      .select("COUNT(supporterships.supportee_id) as supportings_count_at_last_month, users.*")
      .joins(posts: :supporterships_at_last_month).group(:supportee_id)
      .where("supporterships.updated_at" => target_month.beginning_of_month..target_month.end_of_month)
      .includes(:ranking_history)
      .order("supportings_count_at_last_month DESC")
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
        last_month: true, supporter_ranking: true).result

      supporter_photos = supporterships.take(Settings.supporter_photos_num)
        .each_with_object [] do |supportership, photos|
        photos << (supportership.try(:supporter).try(:profile_photo)
          .try(:thumb_small).try :url)
      end
      monthly_ranking.ranking_subtotals.create rank: i, user_id: user.id,
        supportings_count: user.supportings_count_at_last_month,
        supporter_photos: supporter_photos

      case i
      when 1..3
        user.ranking_history.update monthly_1_3: (user.ranking_history
          .monthly_1_3 + 1)
      when 4..10
        user.ranking_history.update monthly_4_10: (user.ranking_history
          .monthly_4_10 + 1)
      when 11..50
        user.ranking_history.update monthly_11_50: (user.ranking_history
          .monthly_11_50 + 1)
      end
    end

    monthly_ranking.update ranker_photos: ranker_photos,
      top_ranker_name: top_ranker_name

    FileUtils.rm_f "#{Settings.page_cache_directory}/v2/rankings/#{previous_monthly_ranking_id}.json"
  end
end
