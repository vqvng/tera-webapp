FROM python:3

WORKDIR /tera-webapp
COPY . /tera-webapp/

RUN pip install -r requirements.txt
RUN pip install -e .

ENV FLASK_APP=app
ENV FLASK_ENV=development

ENTRYPOINT flask run --host=0.0.0.0