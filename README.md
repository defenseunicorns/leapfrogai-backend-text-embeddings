# LeapfrogAI Text Embeddings Backend

## Description

A LeapfrogAI API-compatible embeddings library wrapper for text-based embedding generation.

## Usage

See [instructions](#instructions) to get the backend up and running. Then, use the [LeapfrogAI API server](https://github.com/defenseunicorns/leapfrogai-api) to interact with the backend.

## Instructions

The instructions in this section assume the following:

1. Properly installed and configured Python 3.11.x, to include its development tools
2. The LeapfrogAI API server is deployed and running

<details>
<summary><b>GPU Variation</b></summary>
<br/>
The following are additional assumptions for GPU inferencing:

3. You have properly installed one or more NVIDIA GPUs and GPU drivers
4. You have properly installed and configured the [cuda-toolkit](https://developer.nvidia.com/cuda-toolkit) and [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html)
</details>

### Model Selection

The default model that comes with this backend in this repository's officially released images is a [Instructor-XL](https://huggingface.co/hkunlp/instructor-xl).

Other Instructor-based model sizes and variants can be loaded into this backend by modifying the model repository named in the `scripts/model_download.py` prior to image creation or Makefile command execution.

### Run Locally

Please note that the underlying sentence transformers library will automatically detect and apply GPU or CPU inferencing.

```bash
# Setup Virtual Environment
make create-venv
source .venv/bin/activate
make requirements-dev

# Clone Model
make fetch-model

# Start Model Backend
python main.py
```

### Run in Docker

#### Local Image Build and Run

For local image building and running.

```bash
make docker-build
# without GPU, CPU-only
make docker-run
# with GPU
make docker-run-gpu
```

#### Remote Image Build and Run

For pulling a tagged image from the main release repository.

Where `<IMAGE_TAG>` is the released packages found [here](https://github.com/orgs/defenseunicorns/packages/container/package/leapfrogai%2Fembeddings).

```bash
docker build -t ghcr.io/defenseunicorns/leapfrogai/text-embeddings:<IMAGE_TAG> .
# add the "--gpus all" flag for CUDA inferencing
docker run -p 50051:50051 -d --name text-embeddings ghcr.io/defenseunicorns/leapfrogai/text-embeddings:<IMAGE_TAG>
```
