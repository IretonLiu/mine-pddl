from glob import glob

path = "./problems/tasks/**/numerical/*_problem.pddl"
files = glob(path, recursive=True)
files = sorted(files)
d = {}
for file in files:
    with open(file, "r") as f:
        try:
            # loop until get to init
            line = f.readline()
            while not line.startswith("(:init"):
                line = f.readline()

            # now loop until get to )
            count = 0
            line = f.readline()
            while not line.startswith(")"):
                line = line.strip()
                if line != "":
                    count += 1
                line = f.readline()
            line = f.readline()
            is_valid = line.startswith("(:goal")

            name = file.split("/")[-1]
            if not is_valid:
                print(f"Num File {name} has {count} objects and is valid: {is_valid}")
            else:
                d[name] = {"num": count}
        except Exception:
            print(file, "error")

path = "./problems/tasks/**/propositional/*_problem.pddl"
files = glob(path, recursive=True)
files = sorted(files)
for file in files:
    with open(file, "r") as f:
        try:
            # loop until get to init
            line = f.readline()
            while not line.startswith("(:init"):
                line = f.readline()

            # now loop until get to )
            count = 0
            line = f.readline()
            while not line.startswith(")"):
                line = line.strip()
                if line != "":
                    count += 1
                line = f.readline()
            line = f.readline()
            is_valid = line.startswith("(:goal")

            name = file.split("/")[-1]
            if not is_valid:
                print(f"Prp File {name} has {count} objects and is valid: {is_valid}")
            else:
                d[name]["prop"] = count
        except Exception:
            print(file, "error")

print("===========================================")
prev_key = ""
for key in d.keys():
    if "_".join(prev_key.split("_")[:-2]) not in key:
        print()
    prev_key = key
    print(f"{key} has prop/num = {d[key]['prop']}/{d[key]['num']}")
