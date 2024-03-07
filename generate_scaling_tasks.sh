#!/bin/bash

# This script generates the pddl domain and problem files for a set of progressively larger tasks
# The purpose of these tasks is to find the point at which translation by the planners breaks

# Specifically, we will include only a single line of blocks of varying length
# and the task is to move from the first (central) block to the last block

# define the min and max number of blocks
min_blocks=2
max_blocks=5

# define the base path to store the task YAML files and the generated PDDL
base_yaml_folder="./task-worlds/Scaled_Move_to_Location"
base_pddl_folder="./problems/tasks/Scaled_Move_to_Location"

# create the directories
mkdir -p ${base_yaml_folder}
mkdir -p ${base_pddl_folder}

# these are flags for if the yaml and pddl folders should be emptied
# start with them being True in case the folders are empty - the remove will do nothing
# and only change if the user says "no"
remove_yaml=true
remove_pddl=true

# check if the dirs are empty
if [ "$(ls -A ${base_yaml_folder})" ]; then
    # is not empty
    echo "YAML files found in ${base_yaml_folder}!"
    read -p "Should they be removed? (y/n) " response
    if [ "${response}" != "y" ]; then
        remove_yaml=false
    fi
fi
if [ "$(ls -A ${base_pddl_folder})" ]; then
    # is not empty
    echo "${base_pddl_folder} is not empty!"
    read -p "Should it be emptied? (y/n) " response
    if [ "${response}" != "y" ]; then
        remove_pddl=false
    fi
fi
if [ "${remove_yaml}" = false ] || [ "${remove_pddl}" = false ]; then
    # there are either existing yaml or pddl files that should not be removed
    # so don't remove either
    echo "Not removing any files..."
    exit 1
else
    echo "Removing files..."
    rm -r ${base_yaml_folder}/*
    rm -r ${base_pddl_folder}/*
fi

# loop through the blocks and create the task YAML files
for num_blocks in $(seq $min_blocks $max_blocks); do
    # define the yaml file
    yaml_file="${base_yaml_folder}/Scaled_Move_to_Location_${num_blocks}.yaml"

    # calculate the start and end points
    if [ $((${num_blocks} % 2)) = 0 ]; then
        # even number of blocks
        start_point=$((-(num_blocks / 2)))
        end_point=$(((num_blocks / 2) - 1))
    else
        # odd number of blocks
        # integer division
        start_point=$((-(num_blocks / 2)))
        end_point=$((num_blocks / 2))
    fi

    # create the yaml file - indentation is to the far left since it is carried to the file
    echo "Creating YAML file for ${num_blocks} blocks..."
    cat > ${yaml_file} <<- EOM
# This YAML file has been automatically generated. Any modifications will be overwritten if it is generated again.

# This YAML file will only be used to specify the initial state of the world, and the goal state of the world
# Block and item variants are not currently supported

# the task name
name: "Scaled Move to Location - ${num_blocks} blocks"

# Specify the agent's starting position
agent:
    - position:
        x: '${start_point}'
        y: '4'
        z: '0'

# specify the goal: can be specific blocks placed at specific locations or agent having specific items in the inventory
goal:
    agent:
        - position:
            x: '${end_point}'
            y: '4'
            z: '0'
EOM
done

echo "YAML files created in ${base_yaml_folder}!"
echo
echo "Now generating the PDDL files..."
echo

declare -a pddl_types=("numerical" "propositional")
for pddl_type in ${pddl_types[@]}; do 
    echo "========== Processing ${pddl_type} pddl =========="
    for num_blocks in $(seq $min_blocks $max_blocks); do
        echo "Generating PDDL for ${num_blocks} blocks..."

        # generate the pddl
        yaml_file="${base_yaml_folder}/Scaled_Move_to_Location_${num_blocks}.yaml"
        output_path="${base_pddl_folder}/${pddl_type}/Scaled_Move_to_Location_${num_blocks}/Scaled_Move_to_Location_${num_blocks}"
        python src/main.py \
            --generate-pddl \
            --pddl-type ${pddl_type} \
            --world-config "${yaml_file}" \
            --domain-name "Scaled_Move_to_Location_${num_blocks}" \
            --problem-name "Scaled_Move_to_Location_${num_blocks}_problem" \
            --domain-file "${output_path}_domain.pddl" \
            --problem-file "${output_path}_problem.pddl" \
            --max-inventory-stack 64 \
            --observation-range "(${num_blocks}, 3, 1)" 
        
        # kill the minecraft java process
        pkill -9 -f java
    done
done