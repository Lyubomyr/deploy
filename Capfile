# https://github.com/capistrano-plugins
require 'pp'
require 'fileutils'
require 'securerandom'

require 'sshkit/sudo'
require 'capistrano/setup'

set :stages, %w(staging production)
set :default_stage, 'staging'

require 'capistrano/deploy'
require 'capistrano/postgresql'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

require 'capistrano/rbenv'
# require 'capistrano/rbenv_install'
require 'capistrano/bundler'

require 'capistrano-db-tasks'
require 'capistrano/safe_deploy_to'
require 'capistrano/ssh_doctor'

Rake::Task[:staging].invoke
