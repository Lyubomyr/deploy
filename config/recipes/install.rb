namespace :install do
  desc "Run: cap deploy:setup install=true"
  task :all do
    on roles(:all) do
      if ENV['user']
        invoke("install:adduser_nonpassword")
      end
      if ENV['install'] == "true"
        # invoke("install:secure_root_user")
        sudo "apt-get update"
        invoke "install:dependencies"
        invoke "install:nginx"
        invoke "install:postgresql"
        invoke "install:nodejs"
        invoke "install:bower"
        invoke "install:monit"
        invoke "rvm1:update_rvm_key"
        invoke "rvm1:add_rvm_to_bash"
        # invoke "rvm1:install:rvm" # freeze installation when trying to install rvm here, so will install it during deploy proccess
      end
    end
  end

  task :adduser_nonpassword do
    desc "Run: cap deploy:setup user=root"
    on roles(:all) do
      user = fetch(:deploy_user)
      unless test(:sudo, "grep -c '^#{user}:' /etc/passwd")
        sudo "adduser --disabled-password --gecos '' #{user} --ingroup sudo"
        sudo "echo '#{user}  ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers"
        execute "mkdir /home/#{user}/.ssh"
        set :ssk_public_key, ask('insert your ssh public key', nil)
        sudo "echo '#{fetch(:ssk_public_key)}' >> /home/#{user}/.ssh/authorized_keys"
        info "User added! Now start script again with that user."
      else
        info "User already exists."
      end
      exit
    end
  end

  task :adduser do
    desc "Add system user with username="
    on roles(:all) do
      user = ENV['username'] || fetch(:user)
      unless test(:sudo, "grep -c '^#{user}:' /etc/passwd")
        sudo "adduser --gecos '' #{user} --ingroup sudo"
        info "User #{user} added!"
      else
        info "User #{user} already exists."
      end
      exit
    end
  end

  task :secure_root_user do
    on roles(:all) do
      sudo "passwd root"
      sudo "sed -i 's/^PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config"
      sudo "service ssh restart"
    end
  end

  task :dependencies do
    on roles(:all) do
      sudo "apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core libreadline-dev"
      sudo "apt-get -y install zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxslt1-dev automake"
      sudo "apt-get -y install libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev python-software-properties"
      sudo "apt-get -y install libpq-dev libcurl4-openssl-dev libffi-dev software-properties-common python-software-properties"
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

  task :nodejs do
    on roles(:all) do
      # sudo "add-apt-repository -y ppa:chris-lea/node.js"
      sudo "apt-get update"
      sudo "apt-get -y install nodejs npm nodejs-legacy"
    end
  end

  task :bower do
    on roles(:all) do
      sudo "npm install -g bower"
    end
  end

  task :monit do
    on roles(:all) do
      sudo "apt-get -y install monit"
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

  task :rvm_mixed_mode_ruby do
    on roles(:all) do
      sudo "#{fetch(:rvm_path)} install #{fetch(:ruby_version)}"
    end
  end

  task :rvm do
    on roles(:all) do
      sudo "gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys D39DC0E3"
      # invoke "rvm1:install:rvm"
      sudo "curl -L get.rvm.io | bash -s stable"
      sudo "source ~/.rvm/scripts/rvm"
      sudo "rvm requirements"
    end
  end

  task :rbenv do
    on roles(:all) do
      execute "cd #{fetch(:user_home_path)}"
      execute "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv"
      execute "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bashrc"
      execute "echo 'eval \"$(rbenv init -)\"' >> ~/.bashrc"
      execute "git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
      execute "echo 'export PATH=\"$HOME/.rbenv/plugins/ruby-build/bin:$PATH\"' >> ~/.bashrc"
      execute "source ~/.bashrc"
    end
  end

  task :rbenv_ruby do
    on roles(:all) do
      execute "#{fetch(:rbenv_path)}/bin/rbenv install -v #{fetch(:rbenv_ruby)}"
      execute "echo 'gem: --no-document' > ~/.gemrc"
    end
  end

end
