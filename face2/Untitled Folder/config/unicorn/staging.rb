worker_processes 2

app_directory = "/usr/local/rails_apps/cosplay_server/current"
working_directory app_directory

listen "#{app_directory}/tmp/sockets/unicorn.sock", backlog: 128

timeout 3000

pid "#{app_directory}/tmp/pids/unicorn.pid"

stderr_path "#{app_directory}/log/unicorn_staging.log"
stdout_path "#{app_directory}/log/unicorn_staging.log"

preload_app true

before_exec do |server|
  Dotenv.overload
  ENV["BUNDLE_GEMFILE"] = "#{app_directory}/Gemfile"
end

before_fork do |server,  worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server,  worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
