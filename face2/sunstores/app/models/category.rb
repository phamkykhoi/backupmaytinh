class Category < ActiveRecord::Base
  has_many :category_questions, dependent: :destroy
  has_many :questions, through: :category_questions
  has_many :lessons, dependent: :destroy
  
  validates :name, presence: true
end