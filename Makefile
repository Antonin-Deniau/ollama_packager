.PHONY: convert

model_repo="THUDM/agentlm-8b"
quantization_size=8
output_name=agentlm_8b_q8

convert:
	pip install huggingface_hub
	python download.py $(model_repo)

	git clone https://github.com/ggerganov/llama.cpp.git
	pip install -r llama.cpp/requirements.txt
	python llama.cpp/convert.py model \
								--outfile model.gguf \
								--outtype q$(quantization_size)_0
	ollama create $(output_name) -f Modelfile
