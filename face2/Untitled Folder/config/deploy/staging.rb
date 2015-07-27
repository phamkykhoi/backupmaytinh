server "localhost", user: "deploy", roles: %w{web app db}, my_property: :my_value

set :rails_env, "staging"
set :unicorn_rack_env, "staging"
