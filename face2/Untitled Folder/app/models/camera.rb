class Camera < ActiveRecord::Base
  validates :name, presence: true
end
