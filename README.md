# Production ready containerized Django for Heroku deployment

This repository contains all the necessary files for building docker container to run Django web applications. More specifically, two containers will be created (web service, and db service). In building the docker image for web service, the following softwares are installed:

* [Django web framework](https://www.djangoproject.com)
* [Gunicorn](https://gunicorn.org) - web server gateway interface HTTP server
* [WhiteNoise](https://github.com/evansd/whitenoise) - for serving static files
* [psycopg2](https://pypi.org/project/psycopg2/) - Python PostgreSQL database adapter
* [dj-database-url](https://pypi.org/project/dj-database-url/) - for configuring Django database connection using DATABASE_URL environment variable. This is needed for dynamic deployment on Heroku

The db service simply builds the postgres image from [official docker hub](https://hub.docker.com/_/postgres)

## Development

**Prerequisite** Install [Docker](https://www.docker.com)

After cloning this repository, explore the directory structure, and file contents. The two hidden files (.env, and .db_env) contains the environment variables which are  utilized in building and deploying the docker container. At the very least, makesure to change the Django SECRET_KEY, and database password (SQL_PASSWORD, POSTGRES_PASSWORD), and keep these files out of your version control (e.g. by updating these filenames in .gitignore) 

Execute the following shell scripts in the main repo directory to build and run the containerized django web application.

```console
$ ./up.sh
```
Once the database container is up and running, execute the migrate.sh script to apply migrations to the backend postgresql database

```console
$ ./migrate.sh
```

At this stage your web server will be running on port 7778 (as set in .env file). Point your browser to http://localhost:7778 to verify that your web service is up and running.

The **web** directory is the main Django project directory, which has been mapped to **/web** inside the docker container. This means that if you place any files in this web directory it will be accessible to the docker container. Under the web directory, all the static files are collected under the **static** directory.
Similary the **data/db** directory is mapped as a volume on the **/var/lib/postgresql/data** directory in the db service container. This ensures your data in the database persists in your local directory when the container is removed.   

```console
$ ./down.sh
```

## Deployement

