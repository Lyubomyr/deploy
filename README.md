Workflow on new VPS:
1. Create new user (deploy)
cap setup user=root

2. Then run install command
cap setup install=true

3. Then deploy your project
cap deploy

Commands:
=========

1.   To set up environment use
    ```
    cap <environment> setup
    ```
2.   To set up project use
    ```
    cap <environment> deploy
    ```
3.   To open PG console from local computer use
    ```
    cap <environment> pg:psql
    ```

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
