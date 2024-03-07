from glob import glob

import yaml

path = "./task-worlds/**/*.yaml"
files = glob(path, recursive=True)
files = sorted(files)
prev = ""
for file in files:
    with open(file, "r") as f:
        try:
            yml = yaml.safe_load(f)
            yml = yml["goal"]
            count = 0
            count += 1 if "agent" in yml else 0
            count += len(yml["blocks"]) if "blocks" in yml else 0
            count += len(yml["inventory"]) if "inventory" in yml else 0

            name = file.split("/")[-1]
            if "_".join(name.split("_")[:-1]) not in prev:
                print()
            prev = name
            print(f"File {name} has\t\t {count} objects")
        except Exception:
            print(file, "error")
