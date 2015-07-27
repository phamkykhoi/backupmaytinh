if Rails.env.development? || Rails.env.staging?
  require "rack-mini-profiler"
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
