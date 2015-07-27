class User < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:name, :facebook_id, :twitter_id,
    :google_id, :birthday, :profile_photo, :email, :password, :facebook_token,
    :twitter_token, :google_token, :ticket_recover_notice, :no_login_notice,
    :followee_posts_notice, :supported_notice, :commented_notice,
    :followed_notice, :bulletin_notice, :comment,
    oss_attributes: [:device_token, :type, :registration_id]]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :only_photographer

  acts_as_paranoid
  has_secure_password validations: false

  has_many :posts, dependent: :destroy
  has_many :supported, foreign_key: "supportee_id", dependent: :destroy,
    class_name: "Supportership"
  has_many :supporters, through: :supported, dependent: :destroy
  has_many :followed, foreign_key: "followee_id", dependent: :destroy,
    class_name: "Followership"
  has_many :followers, through: :followed, dependent: :destroy
  has_many :oss, dependent: :destroy, class_name: "Os"
  has_many :ioss, ->{where type: "Ios"},
    {dependent: :destroy, class_name: "Os"}
  has_many :androids, ->{where type: "Android"},
    {dependent: :destroy, class_name: "Os"}
  has_one :request_token, dependent: :destroy
  has_one :ticket, dependent: :destroy
  has_one :ranking_history, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bans, dependent: :destroy

  mount_uploader :profile_photo, ProfilePhotoUploader
  skip_callback :commit, :after, :remove_profile_photo!

  validates :name, presence: true
  validates :login_id, presence: true, unless: ->{only_photographer}
  validates :profile_photo, presence: true, on: :create,
    unless: ->{only_photographer}
  validates :email, presence: true, uniqueness: true,
    format: {with: VALID_EMAIL_REGEX}, if: ->{password}
  validates :password, presence: true, length: {minimum: 8},
    if: ->{email}, on: :create
  validates :login_id, uniqueness: true
  validates :facebook_id, uniqueness: true, allow_nil: true
  validates :google_id, check_account: true, if: ->{google_id}
  validates :google_token, presence: true, if: ->{google_id}
  validates :twitter_id, check_account: true, if: ->{twitter_id}
  validates :twitter_token, presence: true, if: ->{twitter_id}

  accepts_nested_attributes_for :oss

  after_create ->{create_request_token}
  after_create ->{create_ticket}
  after_create ->{create_ranking_history}

  before_create :init

  before_validation :create_login_id, on: :create, unless: ->{login_id.present?}
  after_save :associate_previous_twitter_account, if: ->{changes[:twitter_id]}
  after_save :associate_previous_google_account, if: ->{changes[:google_id]}

  def followership_id_with user
    Followership.find_by(followee_id: user.id, follower_id: id).try :id
  end

  def latest_monthly_rank
    RankingSubtotal.joins(:ranking).where("subtotals.user_id = ? and
      rankings.ends_displaying_at > ? and rankings.type = ?", self.id, Time.zone.now,
      "MonthlyRanking").last.try :rank
  end

  def login?
    !self.request_token.content.nil?
  end

  scope :posts_at_last_month, ->do
    target_month = Time.zone.now - 1.months
    joins(:posts).where("posts.updated_at" => target_month
      .beginning_of_month..target_month.end_of_month)
  end
  scope :supportership_left_join_last_month, ->do
    target_month = Time.zone.now - 1.months
    joins("LEFT JOIN supporterships On users.id = supporterships.supportee_id
      AND supporterships.updated_at BETWEEN '#{target_month.beginning_of_month}'
      AND '#{target_month.end_of_month}'")
  end
  scope :suggesting_for_following, ->user_id do
    followee_ids = Followership.where(follower_id: user_id).pluck :followee_id
    followee_ids << user_id.to_i
    select("count(users.id) as supporter_count,users.*")
      .posts_at_last_month.supportership_left_join_last_month
      .where.not(id: followee_ids)
      .group("posts.user_id, users.id")
      .order("supporter_count DESC")
      .limit Settings.returning_user_suggest_num
  end
  scope :recent, ->{order "id DESC"}

  class << self
    def ransackable_scopes auth_object= nil
      %i(suggesting_for_following)
    end

    def new_remember_token
      SecureRandom.urlsafe_base64
    end

    def encrypt token
      Digest::SHA1.hexdigest token.to_s
    end
  end

  private
  def create_login_id
    self.login_id = loop do
      _login_id = SecureRandom.hex 8
      unless User.exists?(login_id: _login_id)
        break _login_id
      end
    end
  end

  def init
    self.ticket_recover_notice = true
    self.no_login_notice = true
    self.followee_posts_notice = true
    self.supported_notice = true
    self.commented_notice = true
    self.followed_notice = true
    self.bulletin_notice = true
  end

  ransacker :string_id do
    Arel.sql "CONVERT(#{table_name}.id, CHAR(8))"
  end

  [:twitter, :google].each do |sns|
    define_method "associate_previous_#{sns}_account" do
      if user = User.where("#{sns}_id" => send("#{sns}_id")).where
        .not(id: id).first
        user.posts.update_all user_id: id
        Supportership.where(supportee_id: user.id)
          .update_all supportee_id: id
        Followership.where(followee_id: user.id).where.not(follower_id: id)
          .update_all followee_id: id
        ActivityInbox.where(user_id: user.id)
          .update_all user_id: id
        SupportSubtotal.where(user_id: user.id)
          .update_all user_id: id
        RankingSubtotal.where(user_id: user.id)
          .update_all user_id: id

        update_columns posts_count: posts.count,
          followers_count: followers.count

        ranking_history.update({
          daily_1: (ranking_history.daily_1 + user.ranking_history.daily_1),
          daily_2: (ranking_history.daily_2 + user.ranking_history.daily_2),
          daily_3: (ranking_history.daily_3 + user.ranking_history.daily_3),
          monthly_1_3: (ranking_history.monthly_1_3 +
            user.ranking_history.monthly_1_3),
          monthly_4_10: (ranking_history.monthly_4_10 +
            user.ranking_history.monthly_4_10),
          monthly_11_50: (ranking_history.monthly_11_50 +
            user.ranking_history.monthly_11_50)
        })

        user.update_columns "#{sns}_id" => ("pre" + send("#{sns}_id"))
      end
    end
  end
end
