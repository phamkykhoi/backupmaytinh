lock "3.2.1"

set :application, "cosplay_server"
set :repo_url, "git@github.com:framgia/cosplay_server.git"

ask :branch, "master"
set :deploy_to, "/usr/local/rails_apps/#{fetch(:application)}"
set :keep_releases, 5
set :bundle_jobs, 4
set :whenever_identifier, ->{"#{fetch(:application)}_#{fetch(:stage)}"}

set :rbenv_type, :user
set :rbenv_ruby, "2.1.5"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets
  vendor/bundle public/system public/temporally_photos}

set :delayed_job_workers, 2

set :default_env, {
  RAILS_ENV: ENV["RAILS_ENV"],
  MYSQL_HOST: ENV["MYSQL_HOST"],
  MYSQL_USERNAME: ENV["MYSQL_USERNAME"],
  MYSQL_PASSWORD: ENV["MYSQL_PASSWORD"],
  SECRET_KEY_BASE: ENV["SECRET_KEY_BASE"],
  DEVISE_SECRET_KEY: ENV["DEVISE_SECRET_KEY"],
  API_TOKEN: ENV["API_TOKEN"],
  AWS_ACCESS_KEY_ID: ENV["AWS_ACCESS_KEY_ID"],
  AWS_SECRET_ACCESS_KEY: ENV["AWS_SECRET_ACCESS_KEY"],
  AWS_REGION: ENV["AWS_REGION"],
  S3_BUCKET_NAME: ENV["S3_BUCKET_NAME"],
  MONGODB_DATABASE: ENV["MONGODB_DATABASE"],
  MONGODB_HOST: ENV["MONGODB_HOST"],
  APNS_CERTIFICATE_PATH: ENV["APNS_CERTIFICATE_PATH"],
  APNS_PASSWORD: ENV["APNS_PASSWORD"],
  GCM_AUTH_KEY: ENV["GCM_AUTH_KEY"],
  AWS_SES_ADDRESS: ENV["AWS_SES_ADDRESS"],
  AWS_SES_USER_NAME: ENV["AWS_SES_USER_NAME"],
  AWS_SES_PASSWORD: ENV["AWS_SES_PASSWORD"],
  CARRIER_WAVE_ASSET_HOST: ENV["CARRIER_WAVE_ASSET_HOST"]
}

namespace :deploy do
  desc "upload important files"
  task :upload do
    on roles(:app) do |host|
      upload! "config/database.ymls/database.yml.#{fetch(:rails_env)}",
        "#{shared_path}/config/database.yml"
    end
  end
  before "deploy:check:linked_files", :upload

  desc "Create Database"
  task :create_database do
    on roles(:db) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "db:create"
        end
      end
    end
  end
  before :migrate, :create_database

  desc "seed"
  task :seed do
    on roles(:db) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "db:seed"
        end
      end
    end
  end
  after :migrate, :seed

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
      invoke "delayed_job:restart"
    end
  end
  after :publishing, :restart
end
