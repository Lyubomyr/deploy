namespace :pg do
  desc "Setup all PG configuration"
  set :pg_env, fetch(:stage)
  set :pg_encoding, "utf8"
  set :pg_database, "#{fetch(:application)}"
  set :pg_user, "#{fetch(:application)}"
  set :pg_host, "localhost"

  task :setup do
    on roles(:all) do
      template "postgresql.yml.erb", "#{fetch(:shared_path)}/config/database.yml"
    end
  end

  task :sync do
    on roles(:all) do
      sync "#{fetch(:shared_path)}/config/database.yml", "pg", clear: true
    end
  end

end
