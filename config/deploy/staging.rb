set :stage, :staging
set :branch, "staging"
set :rails_env, "staging"
set :nginx_server_name, 'celsus.ufosoft.net'
set :deploy_user, 'ufofactory'
set :deploy_to, '/home/ufofactory/apps/celsus'

role :app, %w{ufofactory@ufosoft.net}
role :web, %w{ufofactory@ufosoft.net}
role :db,  %w{ufofactory@ufosoft.net}

set :linked_files, %w{.env db/staging.sqlite3}

server 'ufosoft.net', user: 'ufofactory', roles: %w{web app}, my_property: :my_value
