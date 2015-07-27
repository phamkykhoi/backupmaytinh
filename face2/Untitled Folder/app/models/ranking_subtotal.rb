class RankingSubtotal < Subtotal
  belongs_to :ranking
  belongs_to :user

  serialize :supporter_photos

  scope :ordered_by_rank_asc, ->{order rank: :asc}
end
