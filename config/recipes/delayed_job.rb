namespace :delayed_job do
  task :script do
    on roles(:web) do
      script "delayed_job.sh", "/etc/init.d/delayed_job"
    end
  end
end
