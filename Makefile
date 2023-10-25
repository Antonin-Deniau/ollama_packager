.PHONY: convert clean

model_repo="THUDM/agentlm-7b"
quantization_size=8
ollama_output_name=agentlm_7b_q8

clean:
	rm -rf llama.cpp
	rm -rf model
	rm -rf model.gguf
	rm -rf /tmp/model

convert:
	pip install huggingface_hub
	python download.py $(model_repo)

	git clone https://github.com/ggerganov/llama.cpp.git
	pip install -r llama.cpp/requirements.txt

	# Fix for the 7b model
	sed -i 's/32256/32000/g' model/config.json

	python llama.cpp/convert.py model \
								--outfile model.gguf \
								--outtype q$(quantization_size)_0

	# Put it in tmp to avoid linux permission issues with the ollama daemon
	mkdir -p /tmp/model
	cp model.gguf /tmp/model/model.gguf
	cp Modelfile /tmp/model/Modelfile
	cd tmp && ollama create $(ollama_output_name)
