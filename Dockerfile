FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-amd64 as builder

# Install the required packages
WORKDIR /leapfrogai
COPY requirements.txt .
RUN pip install -r requirements.txt --user

# Download the model
# TODO: Make the exact mnodel repo configurable. Right now it is hardcoded in the model_download.py script
COPY scripts/model_download.py .
RUN ["python", "model_download.py"]

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-amd64
WORKDIR /leapfrogai
COPY --from=builder /home/nonroot/.local/lib/python3.11/site-packages /home/nonroot/.local/lib/python3.11/site-packages
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/


COPY main.py .

EXPOSE 50051:50051
ENTRYPOINT ["python", "main.py"]