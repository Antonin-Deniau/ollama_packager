.PHONY: convert clean

model_repo="THUDM/agentlm-7b"
quantization_size=8
ollama_output_name=agentlm_7b_q8

clean:
	rm -rf llama.cpp
	rm -rf model
	rm -rf model.gguf

convert:
	pip install huggingface_hub
	python download.py $(model_repo)

	git clone https://github.com/ggerganov/llama.cpp.git
	pip install -r llama.cpp/requirements.txt
	python llama.cpp/convert.py model \
								--outfile model.gguf \
								--outtype q$(quantization_size)_0
	ollama create $(ollama_output_name) -f Modelfile
