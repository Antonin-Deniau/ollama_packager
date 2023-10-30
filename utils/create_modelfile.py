import os
import sys
import jinja2
import yaml

environment = jinja2.Environment()
template = environment.from_string(open("./utils/Modelfile.jinja2").read())

model_id = sys.argv[1]


models_config = yaml.load(open(os.path.join(os.path.dirname(__file__), "../models.yml"), "r"), Loader=yaml.FullLoader)
model_config = models_config["models"][model_id]

params = {}

if "system_prompt" in model_config:
    params["system_prompt"] = model_config["system_prompt"]

if "parameters" in model_config:
    params["parameters"] = model_config["parameters"]

sys.stdout.write(template.render(params))
