from huggingface_hub import snapshot_download
import sys

model_id = sys.argv[1]
model_repo = sys.argv[2]

snapshot_download(
    repo_id=model_repo,
    local_dir=f"../build/{model_id}/model",
    local_dir_use_symlinks=False,
    revision="main"
)
