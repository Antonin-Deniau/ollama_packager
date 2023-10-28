import sys, yaml, os


model_id = sys.argv[1]
var = sys.argv[2]

models_config = yaml.load(open(os.path.join(os.path.dirname(__file__), "../models.yml"), "r"), Loader=yaml.FullLoader)
model_config = models_config["models"][model_id]

sys.stdout.write(model_config[var])