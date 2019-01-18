namespace :nginx do
  desc "Setup all NGINX configuration"
  task :setup do
    on roles(:all) do
      nginx_app_config = fetch(:use_certbot_ssl) ? "nginx_app_with_certbot_ssl.erb" : "nginx_app.erb"
      sudo "rm -f #{fetch(:nginx_app_conf_path)}/default"
      template "nginx.conf.erb", fetch(:nginx_conf_path)
      template nginx_app_config, "#{fetch(:nginx_app_conf_path)}/#{fetch(:application)}"
    end
  end

  task :sync do
    on roles(:all) do
      sync fetch(:nginx_conf_path), "nginx", clear: true
      sync fetch(:nginx_app_conf_path), "nginx", recursive: true
    end
  end

  %w[start stop restart reload force-reload status configtest rotate upgrade].each do |command|
    desc "#{command} nginx server"
    task command do
      on roles(:app), except: {no_release: true} do
        exec = "/etc/init.d/nginx #{command}"
        puts exec
        sudo exec
      end
    end
  end

end
