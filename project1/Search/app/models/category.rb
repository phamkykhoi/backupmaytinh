class Category < ActiveRecord::Base
  has_many :words, dependent: :destroy
  validates :name, uniqueness: true, presence: true
end
