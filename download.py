from huggingface_hub import snapshot_download
import sys


model_repo = sys.argv[1]
snapshot_download(
    repo_id=model_repo,
    local_dir="model",
    local_dir_use_symlinks=False,
    revision="main"
)
