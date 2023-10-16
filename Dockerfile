
FROM python:3.11-slim
COPY requirements.txt .

RUN pip install -r requirements.txt --user

WORKDIR /leapfrogai

COPY main.py .
COPY model/ model/

EXPOSE 50051

ENTRYPOINT ["python", "main.py"]