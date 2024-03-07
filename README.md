# MinePlanner

MinePlanner is a framework to streamline benchmarking planning agents in Minecraft. You can specify the customised world in a YAML file, then use the framework to generate the corresponding Domain and Problem PDDL files, generate a plan using your planning agent of choice, and finally visualising the plan in Minecraft.

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
  
### Converting a Minecraft World to a YAML list of blocks
Provided in the `Utilities` folder is a Jupyter notebook, `World_To_YAML.ipynb` that can assist in converting a standard Java Minecraft save into a list of blocks in the YAML format described above.  

A standard Java Minecraft save folder is needed, which can be found in `.minecraft/saves/`, where this will need to be copied to the `Utilities` directory. Also take note of the name of the world folder as it will need to be specified within the notebook.   

Within the notebook, the `radius` and `world_file_path` parameters need to be specified. The `radius` parameter represents the number of blocks the search will check for, centered around (x, y) = (0, 0). PyBlock will search all y-levels when listing blocks, and is not affected by the radius parameter. The `world_file_path` represents the name of the world folder.  
  
The next cell can then be run which will list all available blocks within the current Minecraft save, within the specified radius. The blocks needed will then need to be added to the dictionary described below that cell in order to translate between the Minecraft naming scheme and the YAML naming scheme.  

The final cell will then search the Minecraft world for each block specified above, and save the list of blocks as `Utilities/block_list.yaml`. This can then be copied into the YAML description file to be used to convert to PDDL.

## Running

There a 3 main tasks that MinePlanner can perform:

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

## Using the provided planners

Two planners have been provided:

- Propositional Planner: Fast Downward
- Numerical Planner: enhsp20

They will be bulit and run using Docker and the Docker Compose plugin, which can be installed using these instructions: [https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

> [!IMPORTANT]
> `<path to domain file>` and `<path to problem file>` are relative to the root directory

### enhsp20

1. Navigate to the enhsp20 directory

    ```shell
    cd containers/enhsp20
    ```

2. Build the image

    ```shell
    docker compose build
    ```

3. Run the planner

    ```shell
    docker compose run enhsp20 -o pddl/<path to domain file> -f pddl/<path to problem file>
    ```

### Fast Downward

1. Navigate to the Fast Downward directory

    ```shell
    cd containers/downward
    ```

2. Build the image

    ```shell
    docker compose build
    ```

3. Run the planner

    ```shell
    docker compose run downward --alias lama-first --plan-file pddl/<path-to-plan-file> pddl/<path-to-domain-file> pddl/<path-to-problem-file>
    ```

## Using the generator scripts

There are two generator scripts: one to generate the domain and problem pddl files for all the provided tasks, and a second one to generate the YAML files and associated domain and problem pddl files for the scaling task.

### Bulk Generator

Run with `./generate_pddl_bulk.sh`.

This script will generate the domain and problem pddl files for all the provided tasks. The behaviour of the script can be modified by changing the valeus of the arrays at the beginning of the script:

- `skip_task_array`: pddl will not be generated for the tasks specified here
- `obsrange_array`: specifies the standard observation ranges for the different levels of difficulty
- `logcabin_obsrange_array` and `cuttree_obsrange_array`: override the standard observation ranges per difficulty level for the Log_Cabin and Cut_Tree tasks. Note that more overrides can be added for other tasks, but this will require editing of the script (although it will be quite similar to the `if` blocks already accounting for Log_Cabin and Cut_Tree).

### Scaled Task Generator

Run with `./generate_scaling_tasks`.

This script will generate the YAML task files and the associated domain and problem pddl files for the Scaled Task. This suite of tasks is special in that it only specifies a single strip of a varying number of blocks for the agent to move over, with the purpose of finding the number of blocks in a task at which planners fail. There are 4 variables in the script that can be edited:

- `min_blocks`: the (inclusive) lower bound of the range of the number of blocks in the tasks
- `max_blocks`: the (inclusive) upper bound of the range of the number of blocks in the tasks
- `base_yaml_folder`: the base path to where the YAML files will be saved
- `base_pddl_folder`: the base path to where the domain and problem files will be saved

The specific tasks in this suite are controlled by the `min_blocks` and `max_blocks` variables, which define the range of the number of blocks in each of the tasks, using a single step increment from the smallest to the largest task.
