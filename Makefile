.PHONY: clean download install_llamacpp package run

model_repo="THUDM/agentlm-13b"
quantization_size=q8_0
ollama_output_name=agentlm_13b_q8

run: download install_llamacpp convert package

clean:
	rm -rf llama.cpp
	rm -rf model
	rm -rf model.gguf
	rm -rf /tmp/model

download:
	pip install huggingface_hub
	python download.py $(model_repo)


install_llamacpp:
	git clone https://github.com/ggerganov/llama.cpp.git
	pip install -r llama.cpp/requirements.txt

convert:
	# Fix for the 7b model
	sed -i 's/32256/32000/g' model/config.json

	python llama.cpp/convert.py model \
								--outfile model.gguf \
								--outtype $(quantization_size)

package:
	# Put it in tmp to avoid linux permission issues with the ollama daemon
	mkdir -p /tmp/model
	cp model.gguf /tmp/model/model.gguf
	cp Modelfile /tmp/model/Modelfile
	cd /tmp/model && ollama create $(ollama_output_name)