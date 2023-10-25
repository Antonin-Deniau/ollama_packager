# AgentML convertion script

Convert the HuggingFace AgentML model to the Ollama format.

## Usage

```bash
make convert model_repo="THUDM/agentlm-13b" quantization_size=q8_0 ollama_output_name=agentlm_13b
```