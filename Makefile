ifndef model_id
$(error model_id is not set)
endif

.PHONY: show_params install_deps download_model convert package run

quantization_size := $(shell python ./utils/get_var.py $(model_id) 'quantization')
model_image_name := $(shell python ./utils/get_var.py $(model_id) 'name')
model_image_tag_name := $(shell python ./utils/get_var.py $(model_id) 'tag')

run: show_params install_deps download_model convert package

show_params:
	@echo "[TASK] Show parameters"

	@echo "[STEP] Model ID: $(model_id)"
	@echo "[STEP] Quantization Size: $(quantization_size)"
	@echo "[STEP] Model Image Name: $(model_image_name)"

install_deps:
	@echo "[TASK] Install dependencies"
	mkdir -p build

	@echo "[STEP] Install python dependencies"
	pip install -r requirements.txt

	@echo "[STEP] Install llama.cpp"
	if [ -d "./build/llama.cpp" ]; then \
		cd ./build/llama.cpp && git reset HEAD && git pull ; \
	else \
		git clone https://github.com/ggerganov/llama.cpp.git ./build/llama.cpp ; \
	fi ;

	@echo "[STEP] Install llama.cpp dependencies"
	pip install -r ./build/llama.cpp/requirements.txt

download_model:
	@echo "[TASK] Download model"
	@echo "[STEP] Init folder structure & delete old model"
	mkdir -p build

	if [ -d "./build/$(model_id)/model" ]; then \
		rm -rf ./build/$(model_id)/model ; \
	fi ;

	@echo "[STEP] Download model"
	python ./utils/download.py $(model_id)

convert:
	@echo "[TASK] Convert model"
	@echo "[STEP] Init folder structure & delete old model"
	mkdir -p build

	if [ -f "./build/$(model_id)/model.gguf" ]; then \
		rm ./build/$(model_id)/model.gguf ; \
	fi ;

	@echo "[STEP] Convert model to .gguf"
	python ./utils/hotfix.py convert $(model_id)
	python ./build/llama.cpp/convert.py ./build/$(model_id)/model \
								--outfile ./build/$(model_id)/model.gguf \
								--outtype $(quantization_size)

package:
	@echo "[TASK] Package model"
	# Note: It's put in tmp to avoid linux permission issues with the ollama daemon

	@echo "[STEP] Init folder structure & delete old model"
	mkdir -p /tmp/models

	if [ -d "/tmp/models/$(model_id)" ]; then \
		rm -rf /tmp/models/$(model_id) ; \
	fi ;

	mkdir -p /tmp/models/$(model_id)

	@echo "[STEP] Create modelfile"
	python ./utils/create_modelfile.py $(model_id) > ./build/$(model_id)/Modelfile

	@echo "[STEP] Copy files & package model for ollama"
	cp -r ./build/$(model_id)/* /tmp/models/$(model_id)/

	python ./utils/hotfix.py package $(model_id)

	cd /tmp/models/$(model_id) && ollama create $(model_image_name):$(model_image_tag_name)
