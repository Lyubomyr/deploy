server '', roles: [:web, :app, :db], port: fetch(:port), user: fetch(:user), primary: true
set :stage, :staging
set :rails_env, 'production'
set :branch, 'master'
