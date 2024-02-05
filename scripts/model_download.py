from huggingface_hub import snapshot_download
import os

os.environ["HF_HUB_ENABLE_HF_TRANSFER"] = "1"

snapshot_download(
    repo_id="hkunlp/instructor-xl",
    local_dir=".model",
    local_dir_use_symlinks=False,
    revision="ce48b213095e647a6c3536364b9fa00daf57f436",
)
