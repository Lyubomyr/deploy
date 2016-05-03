namespace :pg do
  desc "Setup all PG configuration"
  set :pg_env, fetch(:staging)
  set :pg_encoding, "utf8"
  set :database, "#{fetch(:application)}_#{fetch(:staging)}"
  set :username, fetch(:application)
  set :host, "localhost"

  task :setup do
    on roles(:all) do
      invoke "pg:create_user"
      invoke "pg:create_db"
      template "postgresql.yml.erb", "#{fetch(:shared)}/config/database.yml"
    end
  end

  task :sync do
    on roles(:all) do
      sync "#{fetch(:shared)}/config/database.yml", "pg", clear: true
    end
  end

end
