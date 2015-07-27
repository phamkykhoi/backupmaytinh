class Ranking < ActiveRecord::Base
  has_many :ranking_subtotals

  belongs_to :m_ranking_type, class_name: M::RankingType.name
  belongs_to :m_genre, class_name: M::Genre.name

  serialize :ranker_photos

  scope :current, -> do
    where "(starts_displaying_at < ? and ends_displaying_at > ?) or (starts_displaying_at is NULL and ends_displaying_at is NULL)",
      Time.zone.now, Time.zone.now
  end
  scope :ordered_by_custom_order, -> do
    joins(:m_ranking_type).order "m_ranking_types.order ASC"
  end
end
