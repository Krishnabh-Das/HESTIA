FROM ubuntu:22.04
FROM selenium/standalone-chrome
FROM python:3.11.7

WORKDIR /app

COPY . /app

RUN apt update
RUN apt-get install -y libnss3 libgconf-2-4
RUN apt-get install -y chromium-driver 
RUN pip install -r requirements.txt

CMD uvicorn main:app --port=8000 --host=0.0.0.0