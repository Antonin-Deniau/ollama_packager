from huggingface_hub import snapshot_download

snapshot_download(
    repo_id="THUDM/agentlm-13b",
    local_dir="agentlm",
    local_dir_use_symlinks=False,
    revision="main"
)
