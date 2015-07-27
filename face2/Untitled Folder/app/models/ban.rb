class Ban < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:user_id, :reportable_id, :reportable_type]

  acts_as_paranoid

  belongs_to :user
  belongs_to :reportable, polymorphic: true

  validates :user_id, :reportable_id, :reportable_type, presence: true
end
