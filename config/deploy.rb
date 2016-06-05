lock '3.5.0'

server '163.172.133.66', roles: [:web, :app, :db], port: fetch(:port), user: fetch(:user), primary: true
set :application, "team_work_#{fetch :stage}"
set :user, ENV['user'] || 'deploy'
set :deploy_to, "/home/#{fetch(:user)}/applications/#{fetch(:application)}"
set :repo_url, 'git@github.com:Lyubomyr/team_work.git'
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "master"
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :nginx_server_name, 'aol.in.ua'

set :linked_files, %w{config/database.yml config/unicorn.rb config/secrets.yml}
set :linked_dirs, fetch(:linked_dirs, []) + %w{bin log pids}
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

set :log_level, :debug
set :port, 22
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :bundle_binstubs, nil
set :ssh_options, { forward_agent: true, auth_methods: %w(publickey password), user: fetch(:user) }
set :keep_releases, 5

load 'config/config_path.rb'
Dir.glob('config/recipes/*.rb').each { |r| load r }

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} server"
    task command do
      invoke "unicorn:#{command}"
    end
  end
end

before "deploy:set_rails_env", "install:all"
before 'deploy:check:linked_files', 'setup:all'

after 'deploy:publishing', 'deploy:restart'
