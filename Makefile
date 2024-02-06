VERSION ?= $(shell git describe --abbrev=0 --tags | sed -e 's/^v//')
ifeq ($(VERSION),)
  VERSION := latest
endif

ARCH ?= $(shell uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)

.PHONY: all

create-venv:
	python -m venv .venv

activate-venv:
	source .venv/bin/activate

requirements-dev:
	python -m pip install -r requirements-dev.txt

requirements:
	pip-sync requirements.txt requirements-dev.txt

build-requirements:
	pip-compile -o requirements.txt pyproject.toml

build-requirements-dev:
	pip-compile --extra dev -o requirements-dev.txt pyproject.toml

fetch-model:
	python scripts/model_download.py

test:
	pytest **/*.py

dev:
	python main.py

docker-build:
	docker build -t ghcr.io/defenseunicorns/leapfrogai/text-embeddings:${VERSION}-${ARCH} --build-arg ARCH=${ARCH} .

docker-run:
	docker run -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/text-embeddings:${VERSION}-${ARCH}

docker-run-gpu:
	docker run --gpus device=0 -e GPU_ENABLED=true -d -p 50051:50051 ghcr.io/defenseunicorns/leapfrogai/text-embeddings:${VERSION}-${ARCH}

docker-push:
	docker push ghcr.io/defenseunicorns/leapfrogai/text-embeddings:${VERSION}-${ARCH}
