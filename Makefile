.PHONY: convert

convert:
	pip install huggingface_hub
	python download.py
	git clone https://github.com/ggerganov/llama.cpp.git
	pip install -r llama.cpp/requirements.txt
	python llama.cpp/convert.py agentlm \
								--outfile agentlm.gguf \
								--outtype q8_0

	ollama create agentlm_13b_q8 -f Modelfile
