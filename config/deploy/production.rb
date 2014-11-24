set :stage, :production
set :branch, "master"
set :rails_env, "production"
set :nginx_server_name, 'celsus.org'
set :deploy_user, 'celsus'
set :deploy_to, '/home/celsus/celsus'

role :app, %w{celsus@54.65.68.102}
role :web, %w{celsus@54.65.68.102}
role :db,  %w{celsus@54.65.68.102}

set :linked_files, %w{.env}

server '54.65.68.102', user: 'celsus', roles: %w{web app}, my_property: :my_value
