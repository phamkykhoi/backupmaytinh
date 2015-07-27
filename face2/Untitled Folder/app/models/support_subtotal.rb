class SupportSubtotal < Subtotal
  belongs_to :user

  before_create :init

  scope :recent, -> do
    where "targeted_at > ?",
      (Time.zone.now - (Settings.month_displaying_support_subtotal + 1).months)
        .end_of_month
  end

  private
  def init
    self.supporters_count = 0
  end
end
