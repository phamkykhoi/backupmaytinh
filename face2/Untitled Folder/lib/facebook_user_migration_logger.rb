class FacebookUserMigrationLogger < Logger
  include Singleton

  def initialize
    super Rails.root.join("log/facebook_user_migration.log")
  end

  class << self
    delegate :error, :debug, :fatal, :info, :warn, :add, :log, to: :instance
  end
end
