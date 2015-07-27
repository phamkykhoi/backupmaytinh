class Category < ActiveRecord::Base
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates :name, uniqueness: true, presence: true
  scope :category_lesson_user, -> user{
    joins(:lessons)
    .select(" categories.name, lessons.count_correct, lessons.created_at")
    .where("lessons.user_id IN
      (SELECT followed_id FROM relationships WHERE follower_id = '#{user.id}')")}
end
