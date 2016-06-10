namespace :sync do
  desc "Download all config files from server"
  task :all do
    on roles(:all) do
      invoke "nginx:sync"
      invoke "unicorn:sync"
      invoke "sync:logs"
    end
  end

  task :logs do
    on roles(:all) do
      sync "#{fetch(:shared_path)}/log", "/", {clear: true, recursive: true}
    end
  end
end
