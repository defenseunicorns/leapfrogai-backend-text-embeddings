ARG ARCH=amd64

# hardened and slim python w/ developer tools image
FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-dev-${ARCH} as builder

WORKDIR /leapfrogai

# create virtual environment for light-weight portability and minimal libraries
RUN python3.11 -m venv .venv
ENV PATH="/leapfrogai/.venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

# download model
ARG REPO_ID="hkunlp/instructor-xl"
ARG REVISION="ce48b213095e647a6c3536364b9fa00daf57f436"
COPY scripts/model_download.py scripts/model_download.py
RUN REPO_ID=${REPO_ID} REVISION=${REVISION} python scripts/model_download.py

# hardened and slim python image
FROM ghcr.io/defenseunicorns/leapfrogai/python:3.11-${ARCH}

ENV PATH="/leapfrogai/.venv/bin:$PATH"

WORKDIR /leapfrogai

COPY --from=builder /leapfrogai/.venv/ /leapfrogai/.venv/
COPY --from=builder /leapfrogai/.model/ /leapfrogai/.model/

COPY main.py .

EXPOSE 50051:50051

ENTRYPOINT ["python", "-u", "main.py"]
