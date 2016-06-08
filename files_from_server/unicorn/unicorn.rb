working_directory "/home/deploy/applications/team_work_staging/current"

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "/home/deploy/applications/team_work_staging/shared/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "/home/deploy/applications/team_work_staging/current/log/unicorn.stderr.log"
stdout_path "/home/deploy/applications/team_work_staging/current/log/unicorn.stdout.log"

# Set master PID location
pid "/home/deploy/applications/team_work_staging/shared/pids/unicorn.pid"

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
end
