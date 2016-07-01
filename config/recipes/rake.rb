namespace :rake do
  desc 'Install bower'
  task :bower_install do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'bower:install'
        end
      end
    end
  end

end
