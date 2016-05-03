set :rails_env, 'staging'
set :deploy_to, "/home/#{fetch(:user)}/applications/#{fetch(:application)}"
