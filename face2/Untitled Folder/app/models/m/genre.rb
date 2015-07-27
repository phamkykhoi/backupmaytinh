class M::Genre < ActiveRecord::Base
  validates :name, presence: true

  after_create :create_m_ranking_type

  private
  def create_m_ranking_type
    order = M::RankingType.maximum(:order).to_i + 10
    M::RankingType.create name: name, order: order
  end
end
