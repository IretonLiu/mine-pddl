# MineDojo-PDDL

MinePlanneris a framework to streamline benchmarking planning agents in Minecraft. You can specify the customised world in a YAML file, then use the framework to generate the corresponding Domain and Problem PDDL files, generate a plan using your planning agent of choice, and finally visualising the plan in Minecraft.

## Getting Started

These instructions will help you install this framework and get it ready for use.

### Requirements

- `git >= 2.13`
- `python >= 3.9`
- `Java 8` (it is probably worthwhile to use a tool to manage java versions to avoid conflicts with other projects or processes)

### Installation

Install MinePlanner and dependencies:

1. Clone the repository, using SSH

    ```shell
    git clone --recurse-submodules git@github.com:IretonLiu/mine-pddl.git
    ```

    or using HTTPS

    ```shell
    git clone --recurse-submodules https://github.com/IretonLiu/mine-pddl.git
    ```

2. Change the working directory:

    ```shell
    cd mine-pddl
    ```

3. [Optional] Create a python virtual environment

    ```shell
    python -m venv env
    source env/bin/activate
    ```

4. Install python packages

    ```shell
    pip install -r requirements.txt
    ```

## Specifying Minecraft World

MinePlanner uses a YAML config file to specify the configuration of the Minecraft world over-and-above the chosen starting world (e.g. flat, biomes).

An example is provided in [worlds/example.yaml](./worlds/example.yaml). Note that that coordinates and inventory quantities need to be specified as strings.

To get a list of valid block and item types, run:

```shell
python src/main.py --print-valid-types
```

## Running

There a 3 main tasks that MinePlannercan perform:

1. Generate PDDL (`--generate-pddl`): use a YAML config file to generate the Domain and Problem PDDL files.
2. Generate plan (`--generate-plan`): run the specified planning agent, using the specified Domain and Problem files. This is currently not supported: the planner will need to be run manually, but we include instructions for running two basic plannres.
3. Execute plan (`--execute-plan`): visualise the provided plan in the provided world, and save a corresponding video.

There are 2 types of PDDL that can be generated:

1. Propositional PDDL: provide `--pddl-type propositional`
2. Numerical PDDL: provide `--pddl-type numerical`

The framework is run by executing, from the root directory:

```shell
python src/main.py --options
```

For a full list of available arguments:

```shell
python src/main.py --help
```

### Generate PDDL Example

```shell
python src/main.py \
    --generate-pddl \
    --pddl-type propositional \
    --world-config worlds/example.yaml \
    --domain-name first_world \
    --problem-name first_world_problem \
    --domain-file problems/our/domain.pddl \
    --problem-file problems/our/problem.pddl \
    --max-inventory-stack 64 \
    --observation-range "(8, 4, 8)"
```

### Execute Plan Example

```shell
python src/main.py \
    --execute-plan \
    --pddl-type propositional \
    --world-config worlds/example.yaml \
    --plan-file problems/our/plan.pddl \
    --video-save-path problems/our/video \
    --video-name plan_video \
    --max-inventory-stack 64 \
    --observation-range "(8, 4, 8)"
```
