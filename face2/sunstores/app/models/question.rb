class Question < ActiveRecord::Base
  has_many :category_questions, dependent: :destroy
  has_many :categories, through: :category_questions

  has_many :answers, dependent: :destroy
  
  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: :all_blank
  scope :category_questions, ->category_id{joins(:category_questions).where("category_questions.category_id=#{category_id}")}
end
