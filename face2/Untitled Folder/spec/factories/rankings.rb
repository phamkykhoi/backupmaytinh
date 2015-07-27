FactoryGirl.define do
  factory :ranking do
  end

  factory :daily_ranking do
    starts_displaying_at{Time.zone.now.beginning_of_day}
    ends_displaying_at{Time.zone.now.end_of_day}
    m_ranking_type{FactoryGirl.create :m_ranking_type, name: "Dayly"}
    m_genre{FactoryGirl.create :m_genre}
    ranker_photos ["xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg"]
  end

  factory :weekly_ranking do
    starts_displaying_at{Time.zone.now.beginning_of_week}
    ends_displaying_at{Time.zone.now.end_of_week}
    m_ranking_type{FactoryGirl.create :m_ranking_type, name: "Weekly"}
    m_genre{FactoryGirl.create :m_genre}
    ranker_photos ["xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg"]
  end

  factory :monthly_ranking do
    starts_displaying_at{Time.zone.now.beginning_of_month}
    ends_displaying_at{Time.zone.now.end_of_month}
    m_ranking_type{FactoryGirl.create :m_ranking_type, name: "Monthly"}
    m_genre{FactoryGirl.create :m_genre}
    ranker_photos ["xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg"]
  end

  factory :genre_ranking do
    starts_displaying_at nil
    ends_displaying_at nil
    m_ranking_type{FactoryGirl.create :m_ranking_type, name: "Genre"}
    m_genre{FactoryGirl.create :m_genre}
    ranker_photos ["xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg", "xxx.jpg"]
  end
end
