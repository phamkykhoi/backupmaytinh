class DailyRanking < Ranking
  RANGE = "yesterday"

  before_create :init

  private
  def init
    current_day = Time.zone.now
    self.starts_displaying_at = (current_day.beginning_of_day +
      Settings.delayed_time_of_ranking_aggregation)
    self.ends_displaying_at = (current_day.end_of_day +
      Settings.delayed_time_of_ranking_aggregation)
    self.range = (current_day - 1.days).strftime "%b %d, %Y"
  end
end
