import os
import yaml
import sys
from huggingface_hub import snapshot_download


model_id = sys.argv[1]
models_config = yaml.load(open(os.path.join(os.path.dirname(__file__), "../models.yml"), "r"), Loader=yaml.FullLoader)

snapshot_download(
    repo_id=models_config["models"][model_id]["repo"],
    local_dir=f"./build/{model_id}/model",
    local_dir_use_symlinks=False,
    cache_dir=f"./build/cache",
    revision="main"
)
