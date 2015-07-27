class WeeklyRanking < Ranking
  RANGE = "last_week"

  before_create :init

  private
  def init
    current_day = Time.zone.now
    self.starts_displaying_at = (current_day.beginning_of_week +
      Settings.delayed_time_of_ranking_aggregation)
    self.ends_displaying_at = (current_day.end_of_week +
      Settings.delayed_time_of_ranking_aggregation)
    self.range = "week of #{(self.starts_displaying_at - 1.weeks).strftime "%b %d, %Y"}"
  end
end
