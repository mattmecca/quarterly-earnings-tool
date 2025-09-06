# Dashboard instructions
# FROM tells you what Image to start "from"; the :3.10 implies we're starting from the python:3.10 version
FROM python:3.10 
# RUN  apk add python3
WORKDIR /app
# COPY data.csv /data.csv
# Copying the dashboard.py file in our app folder, which is a 
COPY app/dashboard.py .

CMD ['python', 'dashboard.py']