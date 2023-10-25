# AgentML convertion script

Convert the HuggingFace AgentML model to the Oolama format.

## Usage

```bash
# Theses arguments are the default ones, you can omit them
make convert model_repo="THUDM/agentlm-7b" quantization_size=8 ollama_output_name=agentlm_7b_q8
```