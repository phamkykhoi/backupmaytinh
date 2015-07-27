class RankingHistory < ActiveRecord::Base
  before_create :init

  private
  def init
    self.daily_1 = 0
    self.daily_2 = 0
    self.daily_3 = 0
    self.monthly_1_3 = 0
    self.monthly_4_10 = 0
    self.monthly_11_50 = 0
  end
end
