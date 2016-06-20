This project is set of capistrano receipts, which help to deploy your application to new VPS in 20 minutes.
This scripts help you to install all needed software to the server from scratch, then push all configuration files and deploy the project. Also, it helps you to debug issues, read logs, use db and rails consoles and many more.

Setup:
======

1. First you need to download this repo and place it in the root folder of your Rails project.
2. Project has separate Gemset, so you need to install all gems with: bundle install
3. Configure deploy:
- create deploy environments under deploy/config/deploy/
- create environments secrets under deploy/config/deploy/secret
- create your deploy script from exemple in deploy/config/deploy/secret/deploy.rb
- then you should update config varibles in deploy.rb file, minimal set: server, application_name, repo_url, nginx_server_name.

Deploy:
=======

Workflow on new VPS:
1. Create new user (deploy)
cap setup user=root

2. Then run install command
cap setup install=true

3. Then deploy your project
cap deploy

Workflow on new project:
1. Setup
cap production setup

3. Then deploy your project
cap production deploy

Commands:
=========

1.   To set up environmant use
    ```
    cap <environmant> setup
    ```
2.   To set up project use
    ```
    cap <environmant> deploy
    ```
3.   To open PG console from local computer use
    ```
    cap <environmant> pg:psql
    ```
4.   To open rails console from local computer use
    ```
    cap <environmant> pg:psql
    ```
5.   If assets precompile took too many time
    ```
    cap <environmant> pg:psql
    ```

Assets precompile:
=================

If you want precompile assets faster, add next gem to your Gemfile and it will fork compilation for each CPU core:
gem 'sprockets-derailleur', '0.0.9'


Solving problems:
===================

1.   If you faced with next issue `PG::ConnectionBad: FATAL:  password authentication failed for user "<username>"` execute next steps to resolve this problem:
   * open project directory from console and delete next files: "db/database.yml" and "shared/config/database.yml".
   * connect to postgres, remove database and user using next commands from console:
     ```
     cap production pg:psql

     DROP DATABASE <application_name>_<environment>;

     DROP USER <application_name>;
     ```
   * run next commands for creating database, user, database.yml and deploy project:
     ```
     cap <environment> setup

     cap <environment> deploy
     ```


Customization:
==============

In any moment you can change any of the script laying in deploy/config/recipes folder of add your own, enjoy!
