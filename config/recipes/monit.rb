namespace :monit do
  desc "Setup all Monit configuration"
  task :setup do
    on roles(:web) do
      monit_config "monitrc", fetch(:monitrc_path)
    end

    invoke "monit:scripts"
    invoke "monit:templates"

    invoke "monit:syntax"
    invoke "monit:reload"
  end

  task :scripts do
    on roles(:web) do
      script "slack_notifications.sh", "/etc/monit/slack_notifications.sh"
      script "unicorn.sh", "/etc/init.d/unicorn"
      script "delayed_job.sh", "/etc/init.d/delayed_job"
    end
  end

  task :templates do
    invoke "monit:cron"
    invoke "monit:nginx"
    invoke "monit:system"
    invoke "monit:filesystem"
    invoke "monit:sshd"
    invoke "monit:unicorn"
    invoke "monit:delayed_job"
    # invoke "monit:postgresql"
  end

  %w[cron nginx system filesystem sshd unicorn delayed_job postgresql].each do |command|
    desc "Push monit configuration for #{command} to server"
    task command do
      on roles(:web) do
        monit_config command
      end
    end
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:web) do
        sudo "service monit #{command}"
      end
    end
  end
end

def monit_config(name)
  template "monit/#{name}.erb", "#{fetch(:monit_conf_path)}/#{name}.conf"
end
