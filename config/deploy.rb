lock '3.5.0'

server '163.172.154.233', roles: [:web, :app, :db], port: fetch(:port), user: fetch(:user), primary: true
set :application_name, "team_work"
set :nginx_server_name, 'aol.in.ua'

set :application, "#{fetch :application_name}_#{fetch :stage}"
set :user, ENV['user'] || 'deploy'
set :deploy_to, "/home/#{fetch(:user)}/applications/#{fetch(:application)}"
set :repo_url, 'git@github.com:Lyubomyr/team_work.git'
set :branch, ENV["REVISION"] || ENV["BRANCH"] || "master"
set :ruby_version, File.read('.ruby-version').strip
set :rvm1_ruby_version, "#{fetch(:ruby_version)}@#{fetch(:application_name)}"

set :linked_files, %w{config/database.yml config/unicorn.rb config/secrets.yml .rvmrc}
set :linked_dirs, fetch(:linked_dirs, []) + %w{log pids sockets}

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

before "rvm1:hook", "install:all"
before 'deploy:check:linked_files', 'setup:all'

before 'deploy', 'rvm1:install:ruby'
before 'deploy', 'rvm1:install:gems'
before 'deploy', 'rvm1:alias:create'

after 'deploy:check:make_linked_dirs', 'rvm1:create_rvmrc'
after 'deploy:publishing', 'deploy:restart'
