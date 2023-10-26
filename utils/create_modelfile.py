import sys
import jinja2
import yaml

environment = jinja2.Environment()
template = environment.from_string(open("./Modelfile.jinja2").read())

model_id = sys.argv[1]

models_config = yaml.load(open('../models.yml'))
model_config = models_config["models"][model_id]

sys.stdout.write(template.render({
    "gguf_model_path": f"/tmp/models/{model_id}/model.gguf",
    "system_prompt": model_config["system_prompt"],
    "parameters": model_config["parameters"],
}))
