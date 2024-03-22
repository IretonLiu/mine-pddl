#!/bin/zsh

# The only restriction is that the plan name and parent dir must be the same the same for the plan and the yaml file

# define the tasks to skip
declare -a skip_task_array=("PDDL Files" "Farm_Wheat" "Craft_Item" "Grow_Tree")

# define the difficulty levels
declare -a difficulty_array=("Easy" "Medium" "Hard")

# define the base file paths to the files
yaml_base_path="./task-worlds"
plan_base_path="./human-solutions-pddl"

# loop through the tasks, difficulties
for task in "${plan_base_path}"/*; do
    # extract the task name from the file path (it will be the last element)
    task=$(basename $task)

    # check if the task is in the skip array
    if [[ "${skip_task_array[@]}" =~ "\<${task}\>" ]]; then
        echo "========== Skipping task ${task}... =========="
        continue
    fi

    echo "========== Processing task ${task} =========="
    for difficulty in ${difficulty_array[@]}; do
        # define the yaml and plan files
        yaml_file="${yaml_base_path}/${task}/${task}_${difficulty}.yaml"
        plan_file="${plan_base_path}/${task}/${task}_${difficulty}.pddl"

        echo "Validating plan for ${task}_${difficulty}..."

        # check if the yaml file exists - there may be special cases where it does not
        if [ ! -f $yaml_file ]; then
            echo "YAML file ${yaml_file} does not exist! Skipping..."
            continue
        fi

        # validate the plan
        plan_name=$(basename $plan_file ".pddl")
        python src/main.py \
            --execute-plan \
            --pddl-type "propositional" \
            --world-config "${yaml_file}" \
            --plan-file "${plan_file}" \
            --video-save-path "Plans/human_solutions/${plan_name}" \
            --video-name "${plan_name}" \
            --observation-range "(81, 41, 81)" # this is larger than in any task, so it should be fine

        # kill the minecraft java process
        pkill -9 -f java
    done
done
