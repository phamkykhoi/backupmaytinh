class GenreRanking < Ranking
  RANGE = "last_month"

  before_create :init

  private
  def init
    current_day = Time.zone.now
    self.starts_displaying_at = (current_day.beginning_of_month +
      Settings.delayed_time_of_ranking_aggregation)
    self.ends_displaying_at = (current_day.end_of_month +
      Settings.delayed_time_of_ranking_aggregation)
    self.range = (current_day - 1.months).strftime "%b, %Y"
  end
end
