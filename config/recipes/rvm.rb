namespace :rvm1 do
  task :update_rvm_key do
   on roles(:all) do
      execute "gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
    end
  end
end

namespace :rvm1 do
  task :create_rvmrc do
   on roles(:all) do
      template "rvmrc.erb", "#{fetch(:shared_path)}/.rvmrc"
    end
  end
end


namespace :rvm1 do
  task :use_gemset do
   on roles(:all) do
      execute "#{fetch(:rvm1_auto_script_path)} rvm gemset use #{fetch(:application_name)} --create"
    end
  end
end

namespace :rvm1 do
  task :add_rvm_to_bash do
   on roles(:all) do
      execute "echo 'export PATH=\"$HOME/.rvm/bin:$PATH\"' >> ~/.bash_profile"
      execute "echo '[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && source \"$HOME/.rvm/scripts/rvm\"' >> ~/.bash_profile"
    end
  end
end