namespace :aggregate do
  desc "Aggregate genre ranking"
  task genre_ranking: :environment do
    M::Genre.all.each do |genre|
      previous_genre_ranking_id = GenreRanking.last.try :id

      m_ranking_type = M::RankingType.find_by name: genre.name
      genre_ranking = GenreRanking.create m_ranking_type_id: m_ranking_type.id,
        m_genre_id: genre.id

      target_month = Time.zone.now - 1.months
      users = User
        .select("COUNT(supporterships.supportee_id) as supportings_count_with_genre, users.*")
        .joins(posts: :supporterships)
        .where("supporterships.m_genre_id = ? and supporterships.updated_at >= ? and supporterships.updated_at <= ?",
          genre.id, target_month.beginning_of_month, target_month.end_of_month)
        .group(:supportee_id).order("supportings_count_with_genre DESC")
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
          m_genre_id_eq: genre.id, last_month: true, supporter_ranking: true)
          .result

        supporter_photos = supporterships.take(Settings.supporter_photos_num)
          .each_with_object [] do |supportership, photos|
          photos << (supportership.try(:supporter).try(:profile_photo)
            .try(:thumb_small).try :url)
        end
        genre_ranking.ranking_subtotals.create rank: i, user_id: user.id,
          supportings_count: user.supportings_count_with_genre,
          supporter_photos: supporter_photos
      end

      genre_ranking.update ranker_photos: ranker_photos,
        top_ranker_name: top_ranker_name

      FileUtils.rm_f "#{Settings.page_cache_directory}/v2/rankings/#{previous_genre_ranking_id}.json"
    end

    FileUtils.rm_f "#{Settings.page_cache_directory}/v2/rankings/index.json"
  end
end
