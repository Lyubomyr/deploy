namespace :sync do
  desc "Download all config files from server"
  task :all do
    on roles(:all) do
      invoke "nginx:sync"
    end
  end
end
