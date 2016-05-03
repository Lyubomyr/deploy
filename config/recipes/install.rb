# If you want create user use command: cap setup user=root
# And for first installation uncomment next line
# before "deploy:set_rails_env", "install:all"

namespace :install do
  desc "Install everything onto the server"
  task :all do
    on roles(:all) do
      set :user, 'root'
      sudo "apt-get update"
      # invoke "install:adduser"
      invoke "install:dependencies"
      invoke "install:nginx"
      invoke "install:postgresql"
      invoke "install:nodejs"
      invoke "install:monit"
    end
  end

  task :adduser do
    on roles(:all) do
      user_name = "deploy"
      unless test(:sudo, "grep -c '^#{user_name}:' /etc/passwd")
        user = "deploy"
        sudo "adduser --disabled-password --gecos '' #{user} --ingroup sudo"
        sudo "echo '#{user}  ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers"
        execute "mkdir /home/#{user}/.ssh"
        set :ssk_public_key, ask('insert your ssh public key', nil)
        sudo "echo '#{fetch(:ssk_public_key)}' >> /home/#{user}/.ssh/authorized_keys"
        info "User added! Now start script again with that user."
      else
        info "User already exists."
      end
    end
  end

  task :dependencies do
    on roles(:all) do
      sudo "apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core libreadline-dev"
      sudo "apt-get -y install zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxslt1-dev automake"
      sudo "apt-get -y install libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev python-software-properties"
      sudo "apt-get -y install libcurl4-openssl-dev libffi-dev"
    end
  end

  task :nginx do
    on roles(:all) do
      sudo 'apt-get -y install nginx'
    end
  end

  task :postgresql do
    on roles(:all) do
      sudo "apt-get -y install postgresql postgresql-contrib"
    end
  end

  task :rbenv do
    on roles(:all) do
      execute "cd"
      sudo "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv"
      sudo "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bash_profile"
      sudo "echo 'eval \"$(rbenv init -)\"' >> ~/.bash_profile"
      sudo "git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
      sudo "echo 'export PATH=\"$HOME/.rbenv/plugins/ruby-build/bin:$PATH\"' >> ~/.bash_profile"
      sudo "source ~/.bash_profile"
    end
  end

  task :rvm_mixed_mode do
    on roles(:all) do
      sudo "apt-add-repository -y ppa:rael-gc/rvm"
      sudo "apt-get update"
      sudo "apt-get -y install rvm"
      execute "source /etc/profile.d/rvm.sh"
    end
  end

  task :rvm_user do
    on roles(:all) do
      sudo "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
      # invoke "rvm1:install:rvm"
      sudo "curl -L get.rvm.io | bash -s stable"
      sudo "source ~/.rvm/scripts/rvm"
      sudo "rvm requirements"
    end
  end

  task :nodejs do
    on roles(:all) do
      sudo "add-apt-repository -y ppa:chris-lea/node.js"
      sudo "apt-get update"
      sudo "apt-get -y install nodejs"
    end
  end

  task :monit do
    on roles(:all) do
      sudo "apt-get -y install monit"
    end
  end

end
