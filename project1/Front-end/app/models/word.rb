class Word < ActiveRecord::Base
  belongs_to :categories
  has_many   :answers, dependent: :destroy

  validates  :body, presence: true, uniqueness: true
  validates  :category_id, presence: true
  validate   :check_status

  accepts_nested_attributes_for :answers, allow_destroy: true

  private
  def check_status
    if answers.length < 2
      errors.add(:base, "Minimum 2 characters")
    elsif answers.select{|answer| answer.status}.count == 0  
      errors.add(:base, "Please select one correct answer")
    elsif answers.select{|answer| answer.status}.count > 1 
      errors.add(:base, "Only one correct answer is selected")
    end
  end
end
