[日本語はこちら](https://github.com/campbel2525/project-sample/blob/main/README-JAPANESE.md)

# Overview

The server uses FastAPI, and the front end is a SPA with Svelte for user management.  
User management is something I think will be used in any project, so please refer to this repository when creating any project.  
It's a sample, so it has minimal functionality.  
I'm currently learning about FastAPI and Svelte.

Authentication uses JWT.  
The folder structure on the FastAPI side is currently under consideration, and for now, it has been created with reference to Laravel's folder structure.

# About the Development Environment

There are both admin and user sides.

- Admin side API: admin-api
- User side API: user-api
- Admin side front end: admin-front
- User side front end: user-front

Correspondingly.

## 開発環境 url

admin-api
http://localhost:8000/docks  
user-api
http://localhost:8001/docks  
admin-front
http://localhost:3000/  
user-front
http://localhost:3001/

## common

Development environment: docker
Assumed editor: vscode or cursor
Authentication method: jtw

## Environment details on fastapi side

Language: python3.10.0
Framework: fasapi
Debugging: debugpy
Library management: pipenv
orm: sqlalchemy
mysql: 8.0
Formatters, etc.: flake8, mypy, black, isort
jwt: pyJw

## Environment details on svelte side

Framework: svelte
Design framework: sveltestrap
Language: typescript

## How to build the environment

step 1  
If you do not have docker on your PC, please install docker.
Official website: https://code.visualstudio.com/download

Step 2
Run the command below to create a docker development environment

```
make cp-env
make init
```

Step 3
Start the admin-api server with the command below and run it in your browser.
http://localhost:8000/docks
If you access swagger and see swagger, it's OK.

```
make admin-api-run
```

Step 4
Start the admin-front server using the command below and run it in your browser.
http://localhost:3000/
If you access and the screen is displayed, it is OK.

```
make admin-front-run
```

Step 5
Start the user-api server with the command below and run it in your browser.
http://localhost:8001/docks
If you access swagger and see swagger, it's OK.

```
make user-api-run
```

Step 6
Start the user-front server using the command below, and use the browser to
http://localhost:3001/
If you access and the screen is displayed, it is OK.

```
make user-front-run
```

# others

## Rules for push

Execute the following command while the container is running and then push.
The formatter runs and static analysis checks run.

```
make check
```

## How to install the api side library

I will explain using user-api as an example.
Since we are using docker, if we want to install a module, we need to go into the container and install it.
Also, since pipenv is used to manage modules, installation must be performed in a special way.
Here's how to do it

example  
How to install numpy

step 1  
Enter the container with the following command

```
make user-api-shell
```

Step 2
Install numpy with the command below

```
pipenv install numpy
```

## How to install the front side library

Let's take user-front as an example.
Since we are using docker, if we want to install a module, we need to go into the container and install it.
Also, since pipenv is used to manage modules, installation must be performed in a special way.
Here's how to do it

example  
How to install xxx

step 1  
Enter the container with the following command

```
make user-front-shell
```

Step 2
Install xxx with the command below

```
npm install xxx
```

## How to debug with debugpy in vscode

I will explain how to debug using debugpy in vscode
Reference: https://atmarkit.itmedia.co.jp/ait/articles/2107/16/news029.html

How to debug `python/src/sample.py`

step 1  
Install vscode plugin XXX

Step 2
Uncomment debugging of `python/src/sample.py`

Step 3
Refer to "How to run python" and run `python/src/sample.py`

Step 4
Check the console

```
waiting...
```

Check that it is displayed.

Step 5
Set a breakpoint where you want to start debugging

Step 6
Press F5
Debugging will begin.

## About python code format and static analysis

Python has recommended code formats and static analysis to maintain the quality of programming code.
By executing the command below, the python code under python will be automatically formatted and static analysis will be performed.

```
make check
```

## About migration

Tables defined under `app/models` are managed.
If you add a new model file, you need to add it to `app/models/__init__.py`
Migration and migration can be executed by executing the following commands.

### Create migration

```
pipenv run alembic revision --autogenerate -m 'comment'
```

### Migrate

```
pipenv run alembic upgrade head
```

or

```
make migrate
```

# Sample URL

fastapi
https://fastapi.tiangolo.com/ja/

svelte
https://kit.svelte.jp/

svelte reference
https://zenn.dev/wnr/articles/50cnoe5xvzmw

sveltestrap
https://sveltestrap.js.org/?path=/docs/sveltestrap-overview--docs
https://github.com/bestguy/sveltestrap

bootstrap
https://getbootstrap.jp/docs/5.0/components/card/#navigation

# assignment

1. Change authentication to sha512 etc.
2. Get approval?
3. Disadvantages of monorepo

- Namespace error occurs in import statement in each project
  In python, you cannot jump to the reference source of the library. Node (php as well) can fly, so there must be some way.
  The solution is to attach it to the container and open vscode.
  I was able to confirm that it would work if I used workspace and placed ./vscode/settings.json in each folder, but it may be a little tricky since multiple files are opened.
  I'm thinking of responding without using workspace for now.
  To use workspace, uncomment out the file below and select project.code-workspace from the menu "File > Open Workspace with File".
  - apps/admin-api/.vscode
    -apps/user-api/.vscode
  - project.code-workspace

4. Add a refresh token mechanism to the front side
5. Standardize the authentication logic for admin-api- and user-api

## Function name

Please enter the name of each function below.
Anything is fine, but I used djangorest framework as a reference
https://www.django-rest-framework.org/api-guide/viewsets/

- List: index
- Get details: retrieve
- Create: create
- Update: update
- Delete: destroy
