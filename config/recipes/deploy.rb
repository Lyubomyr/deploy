namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} server"
    task command do
      invoke "unicorn:#{command}"
    end
  end

  # namespace :assets do
  #   desc "Precompile assets locally and then rsync to deploy server"
  #   task :precompile_locally, :only => { :primary => true } do
  #     run_locally "bundle exec rake assets:precompile"
  #     servers = find_servers :roles => [:app], :except => { :no_release => true }
  #     servers.each do |server|
  #       run_locally "rsync -av ./public/#{assets_prefix}/ #{user}@#{server}:#{current_path}/public/#{assets_prefix}/"
  #     end
  #     run_locally "rm -rf public/#{assets_prefix}"
  #   end
  # end
end
