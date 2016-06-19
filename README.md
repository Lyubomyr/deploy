Workflow on new VPS:
1. Create new user (deploy)
cap setup user=root

2. Then run install command
cap setup install=true

3. Then deploy your project
cap deploy

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
