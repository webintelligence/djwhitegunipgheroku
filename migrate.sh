#!/bin/bash

docker-compose exec web python manage.py collectstatic
docker-compose exec web python manage.py makemigrations --noinput
docker-compose exec web python manage.py migrate --noinput


