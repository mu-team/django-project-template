FROM python:latest

ENV PYTHONUNBUFFERED 1

WORKDIR /opt

ENTRYPOINT ["docker/entrypoint.sh"]

COPY requirements requirements

RUN pip install -r requirements/common.txt

COPY . .
