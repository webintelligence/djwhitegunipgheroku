#!/bin/bash

source .env

loggedin=`heroku whoami | grep Error | wc -l`

if [[ $loggedin -ne 0 ]]
then
	heroku login
fi

if [[ $APPNAME == "replace_with_heroku_app_name" ]] 
then

	APPNAME=$(heroku create | cut -d '/' -f 3 | cut -d '.' -f 1) 
	echo "Application created: " $APPNAME


fi


appexists=`heroku apps:info -a "$APPNAME" | grep "$APPNAME" | wc -l`


if [[ $appexists -ne 0 ]] 
then
	
	sed -i "" 's/APPNAME\=.*/APPNAME='"$APPNAME"'/' .env
	
	heroku config:set SECRET_KEY=$SECRET_KEY -a $APPNAME

	heroku config:set DJANGO_ALLOWED_HOSTS="$APPNAME.herokuapp.com" -a $APPNAME

	heroku config:set DEBUG=$DEBUG -a $APPNAME 

	heroku container:login

	docker build -t registry.heroku.com/$APPNAME/web ./web/

	docker push registry.heroku.com/$APPNAME/web

	heroku container:release -a $APPNAME web

	postgresexists=`heroku addons -a "$APPNAME" | grep postgresql | wc -l`
	
	if [[ $postgresexists -eq 0 ]] 
	then
		heroku addons:create heroku-postgresql:hobby-dev -a $APPNAME
	fi

	heroku run python manage.py collectstatic --noinput -a $APPNAME

	heroku run python manage.py makemigrations -a $APPNAME

	heroku run python manage.py migrate -a $APPNAME
else
	echo "Heroku application does not exist. Please create one, and update APPNAME in .env file"

fi

