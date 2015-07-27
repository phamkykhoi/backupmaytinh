class AppDriverLogger < Logger
  include Singleton

  def initialize
    super Rails.root.join("log/app_driver.log")
  end

  class << self
    delegate :error, :debug, :fatal, :info, :warn, :add, :log, to: :instance
  end
end
