namespace :aggregate do
  desc "Aggregate daily ranking"
  task daily_ranking: :environment do
    previous_daily_ranking_id = DailyRanking.last.try :id

    daily_ranking = DailyRanking.create m_ranking_type_id: 1

    target_datetime = Time.zone.now - 1.days
    users = User
      .select("COUNT(supporterships.supportee_id) as supportings_count_yesterday, users.*")
      .joins(posts: :supporterships_yesterday)
      .where("supporterships.updated_at" => target_datetime.beginning_of_day..target_datetime.end_of_day)
      .includes(:ranking_history)
      .group(:supportee_id)
      .order("supportings_count_yesterday DESC")
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
        yesterday: true, supporter_ranking: true).result

      supporter_photos = supporterships.take(Settings.supporter_photos_num)
        .each_with_object [] do |supportership, photos|
        photos << (supportership.try(:supporter).try(:profile_photo)
          .try(:thumb_small).try :url)
      end
      daily_ranking.ranking_subtotals.create rank: i, user_id: user.id,
        supportings_count: user.supportings_count_yesterday,
        supporter_photos: supporter_photos

      case i
      when 1
        user.ranking_history.update daily_1: (user.ranking_history.daily_1 + 1)
      when 2
        user.ranking_history.update daily_2: (user.ranking_history.daily_2 + 1)
      when 3
        user.ranking_history.update daily_3: (user.ranking_history.daily_3 + 1)
      end
    end

    daily_ranking.update ranker_photos: ranker_photos,
      top_ranker_name: top_ranker_name

    FileUtils.rm_f "#{Settings.page_cache_directory}/v2/rankings/#{previous_daily_ranking_id}.json"
    FileUtils.rm_f "#{Settings.page_cache_directory}/v2/rankings/index.json"
  end
end
