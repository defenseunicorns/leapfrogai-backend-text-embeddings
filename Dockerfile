ARG ARCH=amd64

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-${ARCH} as builder

WORKDIR /leapfrogai

RUN pip install huggingface_hub
COPY scripts/model_download.py .
RUN python model_download.py

RUN python3.11 -m venv .venv
ENV PATH="/leapfrogai/.venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-${ARCH}

ENV PATH="/leapfrogai/.venv/bin:$PATH"

WORKDIR /leapfrogai

COPY --from=builder /leapfrogai/.venv/ /leapfrogai/.venv/
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .

EXPOSE 50051:50051

ENTRYPOINT ["python", "-u", "main.py"]
