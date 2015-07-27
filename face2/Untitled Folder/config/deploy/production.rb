server "localhost", user: "deploy", roles: %w{web app db}, my_property: :my_value

set :rails_env, "production"
set :unicorn_rack_env, "production"
