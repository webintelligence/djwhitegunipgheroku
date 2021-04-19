FROM python:3.8

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /web

COPY ./requirements.txt /web
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . /web

RUN chown -R www-data:www-data /web  

USER www-data

CMD gunicorn web.wsgi:application --bind 0.0.0.0:$PORT
