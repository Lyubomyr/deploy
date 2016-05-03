#LOCAL
set :templates_path, "config/templates"
set :scripts_path, "config/scripts"
set :download_path, "config/files_from_server"

#SERVER
set :user_home_path, "/home/#{fetch(:user)}"
set :app_home_path, "#{fetch(:user_home_path)}/applications/#{fetch(:application)}"
set :shared_path, "#{fetch(:app_home_path)}/shared"
set :current_path, "#{fetch(:app_home_path)}/current"

#NGINX
set :nginx_conf_path, "/etc/nginx/nginx.conf"
set :nginx_app_conf_path, "/etc/nginx/sites-enabled"

#UNICORN
set :unicorn_conf_path, "#{fetch(:shared_path)}/config/unicorn.rb"
set :unicorn_pid_path, "#{fetch(:shared_path)}/pids/unicorn.pid"
set :unicorn_sock_path, "#{fetch(:shared_path)}/sockets/unicorn.sock"

#MONIT
set :monitrc_path, "/etc/monit/monitrc"
set :monit_conf_path, "/etc/monit/conf.d"
