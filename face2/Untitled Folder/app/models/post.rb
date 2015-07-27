class Post < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:m_genre_id, :user_id, :camera_id, :download,
    :location, :photographer_id, :from, photos_attributes: [:description,
      :content, :main, :width_ratio, :height_ratio, :temporally_photo_url],
    tag_ids: []]

  attr_accessor :from

  acts_as_paranoid

  paginates_per Settings.returning_post_num

  has_many :supporterships, dependent: :destroy
  has_many :supporterships_yesterday,  -> do
    target_day = Time.zone.now - 1.days
    where updated_at: target_day.beginning_of_day..target_day.end_of_day
  end,  {class_name: "Supportership"}
  has_many :supporterships_at_last_week,  -> do
    target_week = Time.zone.now - 1.weeks
    where updated_at: target_week.beginning_of_week..target_week.end_of_week
  end,  {class_name: "Supportership"}
  has_many :supporterships_at_last_month,  -> do
    target_month = Time.zone.now - 1.months
    where updated_at: target_month.beginning_of_month..target_month.end_of_month
  end,  {class_name: "Supportership"}
  has_many :supporters, through: :supporterships
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bans, dependent: :destroy, as: :reportable
  has_many :activities, as: :trackable, dependent: :destroy

  belongs_to :user
  belongs_to :photographer, class_name: User.name
  belongs_to :m_genre, class_name: M::Genre.name
  belongs_to :camera

  has_and_belongs_to_many :tags

  counter_culture :user

  validates :user_id, :m_genre_id, presence: true
  validates :photos, presence: true, if: ->{from == "web"}

  accepts_nested_attributes_for :photos

  scope :ordered_by_comments_count_desc, ->boolean = true do
    order comments_count: :desc
  end
  scope :ordered_by_supporters_count_desc, ->boolean = true do
    order supporters_count: :desc
  end
  scope :recent, ->boolean = true do
    order updated_at: :desc
  end
  scope :supporting_recent, ->boolean = true do
    joins(:supporterships).order("MAX(supporterships.updated_at) DESC")
      .group "posts.id"
  end
  scope :posted_user_followed_by, ->user_id do
    joins(user: [:followed]).where "followerships.follower_id" => user_id
  end
  scope :with_bans_count, ->do
    select("posts.*, COUNT(bans.reportable_id) as bans_count").joins(:bans)
      .group "bans.reportable_id"
  end
  scope :without_not_associating_photos, -> do
    includes(:photos).where.not("photos.post_id" => nil)
  end

  def supporters_count_from_user user
    supporterships.where(supporter: user).count
  end

  after_commit :create_activity, on: :create
  after_destroy :update_counter_culture

  def reported? user
    !self.bans.find_by(user_id: user.id).nil?
  end

  class << self
    def ransackable_scopes auth_object= nil
      %i(ordered_by_comments_count_desc ordered_by_supporters_count_desc
        recent posted_user_followed_by supporting_recent)
    end
  end

  private
  def update_counter_culture
    user.update! posts_count: user.posts.count
  end

  def create_activity
    body = %W(/#{user.name}/ #{M::ActivityTemplate
      .find_by(key: self.class.name).try :text}).join " "
    activity = activities.create user_id: user_id, body: body
    user.followers.find_each do |follower|
      activity.activity_inboxes.create user_id: follower.id
      content = {message: body.delete("/"), user_id: user_id, target_id: id, type: "Post"}
      if follower.followee_posts_notice && follower.login?
        Notification.send_to follower, content
      end
    end
  end

  handle_asynchronously :create_activity, priority: 40
end
