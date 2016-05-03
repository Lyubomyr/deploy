lock '3.5.0'

server '163.172.149.164', roles: [:web, :app, :db], port: fetch(:port), user: fetch(:user), primary: true
set :application, 'team_work'
set :user, ENV['user'] || 'deploy'
set :repo_url, 'git@github.com:Lyubomyr/team_work.git'
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "master"
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
# set :tmp_dir, "/home/#{fetch(:user)}/tmp"
set :nginx_server_name, 'aol.in.ua'

set :pg_templates_path, "config/templates"

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

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true} do
        puts "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
        run "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end
end

after 'deploy:publishing', 'deploy:restart'

load 'config/config_path.rb'
Dir.glob('config/recipes/*.rb').each { |r| load r }
