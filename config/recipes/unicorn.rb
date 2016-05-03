namespace :unicorn do
  desc "Setup all Unicorn configuration"
  task :setup do
    on roles(:all) do
      template "unicorn.rb.erb", fetch(:unicorn_conf_path)
    end
  end

  task :sync do
    on roles(:all) do
      sync fetch(:unicorn_conf_path), "unicorn", clear: true
    end
  end
end
