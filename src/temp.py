import yaml


def main():
    # convert json to yaml
    with open('worlds/example.json', 'r') as f:
        data = yaml.safe_load(f)
    with open('worlds/example.yaml', 'w') as f:
        yaml.dump(data, f)

if __name__ == "__main__":
    main()


