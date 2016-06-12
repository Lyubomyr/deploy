namespace :setup do
  desc "Provisioning files"
  task :all do
    on roles(:all) do
      invoke "yml:setup"
      invoke "nginx:setup"
      invoke "unicorn:setup"
      invoke "unicorn:script"
    end
  end
end

namespace :yml do
  desc "staging.yml.erb from secrets folder"
  task :setup do
    template "../deploy/secrets/#{fetch(:stage)}.yml.erb", fetch(:yml_conf_path)
  end
end

def upload(from, to, opt={})
  user = opt[:user] || "root"
  group = opt[:group] || "root"
  executable = opt[:execute]
  content = opt[:content]

  file_content = content || File.new(from).read
  file = ERB.new(file_content).result(binding)
  tmp = "/tmp/#{File.basename(from, ".erb")}"
  on roles(:all) do
    upload! StringIO.new(file), tmp
    sudo "chmod 644 #{tmp}"
    sudo "chown #{user}:#{group} #{tmp}"
    # sudo "touch #{tmp}"
    sudo "chmod +x #{tmp}" if executable
    sudo "mv #{tmp} #{to}"
  end
end

def template(name, to, opt={})
  upload "#{fetch(:templates_path)}/#{name}", to, opt
end

def script(name, to, opt={})
  opt.merge!(execute: true)
  upload "#{fetch(:scripts_path)}/#{name}", to, opt
end

def sync(from, service_name, opt={})
  to = "#{fetch(:download_path)}/#{service_name}"
  if opt.delete(:clear)
    clear_folder = opt[:recursive] ? "#{to}/#{from.split("/").last}" : to
    FileUtils.rm_rf clear_folder
    FileUtils::mkdir_p clear_folder
  end
  download! from, to, opt
end
