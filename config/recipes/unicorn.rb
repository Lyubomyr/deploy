namespace :unicorn do
  set :unicorn_name, "unicorn_#{fetch(:application)}"

  desc "Setup all Unicorn configuration"
  task :setup do
    on roles(:all) do
      template "unicorn.rb.erb", fetch(:unicorn_conf_path)
    end
  end

  task :sync do
    on roles(:all) do
      sync fetch(:unicorn_conf_path), "unicorn", clear: true
      sync "/etc/init.d/#{fetch(:unicorn_name)}", "unicorn"
    end
  end

  task :script do
    on roles(:web) do
      script "unicorn.sh.erb", "/etc/init.d/#{fetch(:unicorn_name)}"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), except: {no_release: true} do
        puts "/etc/init.d/#{fetch(:unicorn_name)} #{command}"
        sudo "/etc/init.d/#{fetch(:unicorn_name)} #{command}"
      end
    end
  end
end
