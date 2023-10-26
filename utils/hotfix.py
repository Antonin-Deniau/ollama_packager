import sys, yaml, os

step = sys.argv[1]
model_id = sys.argv[2]

models_config = yaml.load(open('../models.yml'))
model_config = models_config["models"][model_id]

hotfixes = model_config['hotfixes']
curr_step_hotfixes = [x for x in hotfixes if x['step'] == step]

for hotfix in curr_step_hotfixes:
    print(f"Running hotfix: {hotfix['description']}")
    print(f"Executing: {hotfix['cmd']}")
    os.system(hotfix['cmd'])
