namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console do
    on roles(:all) do
      interact "#{fetch(:bundle_exec)} rails c #{fetch(:rails_env)}"
    end
  end

  desc "rake db:seed"
  task :seed do
    on roles(:all) do
      execute "#{fetch(:bundle_exec)} rake db:seed RAILS_ENV=#{fetch(:rails_env)}"
    end
  end
end
