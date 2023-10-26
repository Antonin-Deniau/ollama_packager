.PHONY: download install_llamacpp package run

model_repo="THUDM/agentlm-13b"
quantization_size=q8_0
ollama_output_name=agentlm_13b_q8

run: download install_llamacpp convert package

download:
	rm -rf model
	pip install huggingface_hub
	python download.py $(model_repo)


install_llamacpp:
	rm -rf llama.cpp
	git clone https://github.com/ggerganov/llama.cpp.git
	pip install -r llama.cpp/requirements.txt

convert:
	rm -rf model.gguf
	# Fix for the model, the true size is 32000 (cat model/tokenizer.json |jq '.model.vocab | length)
	sed -i 's/32256/32000/g' model/config.json

	python llama.cpp/convert.py model \
								--outfile model.gguf \
								--outtype $(quantization_size)

package:
	rm -rf /tmp/model
	# Put it in tmp to avoid linux permission issues with the ollama daemon
	mkdir -p /tmp/model
	cp model.gguf /tmp/model/model.gguf
	cp Modelfile /tmp/model/Modelfile
	cd /tmp/model && ollama create $(ollama_output_name)
