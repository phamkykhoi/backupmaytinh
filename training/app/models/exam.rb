class Exam < ActiveRecord::Base
  has_many :questions
  validates :name, presence: true, uniqueness: true
  validates :time, presence: true
end
