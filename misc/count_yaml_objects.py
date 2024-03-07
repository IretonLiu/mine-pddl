from glob import glob

import yaml

path = "./task-worlds/**/*.yaml"
files = glob(path, recursive=True)
files = sorted(files)
for file in files:
    with open(file, "r") as f:
        try:
            yml = yaml.safe_load(f)
            count = 0
            count += len(yml["blocks"]) if "blocks" in yml else 0
            count += len(yml["items"]) if "items" in yml else 0
            print(f"File {file.split('/')[-1]} has\t\t {count} objects")
        except Exception:
            print(file, "error")
