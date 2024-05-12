## [日本語はこちら](https://github.com/campbel2525/test-project-sample/blob/main/README-JAPANESE.md)

# Note

It's still under development, so the code will change a lot.

# Technology stack

Backend side: python fastapi
Front end side: next.js(app router)
Infrastructure: AWS
iac:terraform
Development environment: docker

# overview

I created a simple sample app where the user can register as a member on the user screen and edit it on the management screen.
I think this feature will be used in any project, so please refer to this repository when creating a project.
It also incorporates formatters, static analysis, debugging, etc.

I'm currently thinking about the folder structure of fastapi, and I made it based on the folder structure of laravel.
I'm still learning fastapi and next.js, so I apologize if there are any mistakes.

# Development environment

We have created an administrator side and a user side. The following URLs are supported

- Admin side api: admin-api
  - http://localhost:8000/docks
- User-side api: user-api
  - http://localhost:8001/docks
- Admin front: admin-front
  - http://localhost:3000/
- User-side front: user-front
  - http://localhost:3001/

## Sample user

Management side
admin1@example.com
test1234

User side
user1@example.com
test1234

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

Step 3 How to start admin-api

```
make admin-api-run
```

in your browser by running
http://localhost:8000/docks
access

Step 4 How to launch admin-front

```
make admin-front-run
```

in your browser by running
http://localhost:3000/
access

Step 5 How to start user-api

```
make user-api-run
```

in your browser by running
http://localhost:8001/
access

Step 6 How to launch user-front

```
make user-front-run
```

in your browser by running
http://localhost:3001/
access

# About iac

reference

# others

## Rules for push

Please run the following command while the container is running before pushing.
Runs formatters on the backend side and frontend side, static analysis checks, etc.

```
make check
```

## How to install the api side library

I will explain using admin-api as an example.
Since we are using docker, if we want to install a module, we need to go into the container and install it.
Also, since pipenv is used to manage modules, installation must be performed in a special way.
Here's how to do it

example
How to install numpy

step 1
Enter the container with the following command

```
make admin-api-shell
```

Step 2
Install numpy with the command below

```
pipenv install numpy
```

## How to install the front side library

Let's take admin-front as an example.
Since we are using docker, if we want to install a module, we need to go into the container and install it.
Also, since pipenv is used to manage modules, installation must be performed in a special way.
Here's how to do it

example
How to install xxx

step 1
Enter the container with the following command

```
make admin-front-shell
```

Step 2
Install xxx with the command below

```
npm install xxx
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
  - apps/user-api/.vscode
  - project.code-workspace

4. Add a refresh token mechanism to the front side
5. Standardize the authentication logic for admin-api- and user-api

## function name of restapi

Please enter the name of each function below.
Anything is fine, but I used djangorest framework as a reference
https://www.django-rest-framework.org/api-guide/viewsets/

- List: index
- Get details: retrieve
- Create: create
- Update: update
- Delete: destroy

# Operation

## Branch operation

The expected branch will be as follows
main branch: development
(stg branch: staging branch)
prod branch: production branch

## Deployment flow

The deployment flow is as follows:

1. Create a pull request for main branch -> prod branch
2. Tests are executed on github
3. Check that the tests completed correctly and merge them into the prod branch. This triggers the cicd below to be executed.
4. Both the front and back ends are built
5. Build the admin-api for migration and run the migration (Building here is useless. Why not just use what was built in the previous step?)
6. Deploy each of the above four projects
