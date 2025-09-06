# Earnings model instructions
FROM python:3.10
FROM ubuntu
RUN apt-get update
RUN apt-get install -y python3
COPY data.csv /data.csv
COPY earnings_model.py /earnings_model.py

CMD  ['python' '/earnings_model.py']