class M::RankingType < ActiveRecord::Base
  validates :name, :order, presence: true
end
