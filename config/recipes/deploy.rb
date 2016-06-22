namespace :deploy do
  desc "compiles assets locally then rsyncs"
  task :compile_assets_locally do
    on roles(:app) do |role|
      assets_path = "public/assets/"
      assets_tmp_path = "tmp/cache/assets/production/"
      mkdir "#{fetch(:shared_path)}/#{assets_path}"
      mkdir "#{fetch(:shared_path)}/#{assets_tmp_path}"
      run_locally do
        execute"rsync -av ../#{assets_path} deploy@#{role.hostname}:#{fetch(:shared_path)}/#{assets_path};"
        execute"rsync -av ../#{assets_tmp_path} deploy@#{role.hostname}:#{fetch(:shared_path)}/#{assets_tmp_path}"
      end
      sudo "chmod -R 755 #{fetch(:shared_path)}/#{assets_path}"
      sudo "chmod -R 755 #{fetch(:shared_path)}/#{assets_tmp_path}"
      invoke "deploy:assets:backup_manifest"
    end
  end
end


# Need this to make capistrano-db-tasks work, because deploy folder is out of project
module Database
  class Local < Base
    def initialize(cap_instance)
      super(cap_instance)
      @config = YAML.load(ERB.new(File.read(File.join('..', 'config', 'database.yml'))).result)[fetch(:local_rails_env).to_s]
      puts "local #{@config}"
    end
  end
end
