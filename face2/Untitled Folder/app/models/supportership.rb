class Supportership < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:post_id]

  acts_as_paranoid

  has_many :activities, as: :trackable, dependent: :destroy

  belongs_to :post
  belongs_to :m_genre, class_name: M::Genre.name
  belongs_to :supporter, class_name: User.name
  belongs_to :supportee, class_name: User.name

  scope :yesterday, ->boolean = true do
    target_day = Time.zone.now - 1.days
    where updated_at: target_day.beginning_of_day..target_day.end_of_day
  end
  scope :last_week, ->boolean = true do
    target_week = Time.zone.now - 1.weeks
    where updated_at: target_week.beginning_of_week..target_week.end_of_week
  end
  scope :last_month, ->boolean = true do
    target_month = Time.zone.now - 1.months
    where updated_at: target_month.beginning_of_month..target_month.end_of_month
  end
  scope :supporter_ranking, ->boolean = true do
    select("COUNT(supporterships.supporter_id) AS supportings_count, supporterships.*")
      .includes(:supporter).group(:supporter_id).order("supportings_count DESC")
      .limit Settings.returning_supporter_ranking_num
  end

  counter_culture :post, column_name: :supporters_count
  counter_culture :supporter, column_name: :supportings_count

  validates :supporter_id, :post_id, presence: true

  before_create :init

  after_create :create_activity, :decrease_ticket, :count_up_subtotal


  class << self
    def ransackable_scopes auth_object= nil
      %i(yesterday last_week last_month supporter_ranking)
    end
  end

  private
  def init
    self.m_genre_id = post.try :m_genre_id
    self.supportee_id = post.try :user_id
  end

  def create_activity
    body = %W(/#{supporter.name}/ #{M::ActivityTemplate
      .find_by(key: self.class.name).try :text}).join " "
    activity = activities.create user_id: supporter_id, body: body

    unless supportee == supporter
      activity.activity_inboxes.create user_id: supportee_id
      content = {message: body.delete("/"), post_id: post.id, target_id: post.id, type: "Supportership"}
      if supportee.supported_notice && supportee.login?
        Notification.send_to supportee, content
      end
    end
  end

  def decrease_ticket
    supporter.ticket.update decrease: 1
  end

  def count_up_subtotal
    support_subtotal = SupportSubtotal
      .find_or_create_by targeted_at: created_at.beginning_of_month,
        user_id: supportee.id
    count = support_subtotal.supporters_count + 1
    support_subtotal.update supporters_count: count
  end
end
