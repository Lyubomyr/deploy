def upload(from, to, opt={})
  user = opt[:user] || "root"
  group = opt[:group] || "root"
  executable = opt[:execute]
  file = ERB.new(File.new(from).read).result(binding)
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
    FileUtils.rm_rf to
    FileUtils::mkdir_p to
  end
  download! from, to, opt
end
