class User < ActiveRecord::Base
  has_many :microposts
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
                                   
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token
  before_save { self.email = email.downcase }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # validates :fullname,  presence: true, length: { maximum: 50 }
  # validates :email, confirmation: true, uniqueness: true,
  #           :presence => {:message => "Vui long nhap Email" },
  #           :format   => { :with => VALID_EMAIL_REGEX, :message => "Email is invalid format"}     
  # validates :address, presence: true
  # validates :phone, presence: true
  # has_secure_password
  # validates :password, confirmation: true, presence: true, allow_blank: true

  mount_uploader :avarta, AvartaUploader
  validate  :picture_size

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def picture_size
    if avarta.size > 2.megabytes
      errors.add(:avarta, "should be less than 2MB")
    end
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end


end