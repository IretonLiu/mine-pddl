#!/bin/zsh

# define the tasks to skip
declare -a skip_task_array=("PDDL Files" "Farm_Wheat" "Craft_Item" "Grow_Tree")

# define the difficulty levels
declare -a difficulty_array=("Easy" "Medium" "Hard")

# define the default observation ranges, as well as any task-specific overrides
# note that the overrides will have to specially handled later on
declare -A obsrange_array=(
    [Easy]="(8, 4, 8)" 
    [Medium]="(15, 8, 15)" 
    [Hard]="(65, 25, 65)"
)
declare -A logcabin_obsrange_array=(
    [Easy]="(20, 10, 20)" 
    [Medium]="(40, 10, 40)" 
    [Hard]="(65, 10, 65)"
)
declare -A cuttree_obsrange_array=(
    [Easy]="(20, 30, 20)" 
    [Medium]="(40, 30, 40)" 
    [Hard]="(65, 30, 65)"
)

# define the pddl types
declare -a pddl_types=("numerical" "propositional")

# loop through the tasks, difficulties, and pddl types
for task in ./task-worlds/*; do
    # extract the task name from the file path (it will be the last element)
    task=$(basename $task)

    # check if the task is in the skip array
    if [[ "${skip_task_array[@]}" =~ "${task}" ]]; then
        echo "========== Skipping task ${task}... =========="
        continue
    fi

    echo "========== Processing task ${task} =========="
    for difficulty in ${difficulty_array[@]}; do 
        for pddl_type in ${pddl_types[@]}; do 
            # define the task folder and yaml file
            task_folder="./task-worlds/${task}/${task}_${difficulty}"
            yaml_file="${task_folder}.yaml"

            # define the observation range, and check if there is a task-specific override
            obsrange=${obsrange_array[$difficulty]}
            if [ $task = "Build_Log_Cabin" ]; then
                obsrange=${logcabin_obsrange_array[$difficulty]}
            elif [ $task = "Cut_Tree" ]; then
                obsrange=${cuttree_obsrange_array[$difficulty]}
            fi
            
            echo "Generating PDDL for ${task}_${difficulty} for ${pddl_type} pddl..."

            # check if the yaml file exists - there may be special cases where it does not
            if [ ! -f $yaml_file ]; then
                echo "YAML file ${yaml_file} does not exist! Skipping..."
                continue
            fi 
            
            # generate the pddl
            output_path="problems/tasks/${task}/${difficulty}/${pddl_type}/${task}_${difficulty}"
            python src/main.py \
                --generate-pddl \
                --pddl-type ${pddl_type} \
                --world-config "${yaml_file}" \
                --domain-name "${task}_${difficulty}" \
                --problem-name "${task}_${difficulty}_problem" \
                --domain-file "${output_path}_domain.pddl" \
                --problem-file "${output_path}_problem.pddl" \
                --max-inventory-stack 64 \
                --observation-range "${obsrange}" 
            
            # kill the minecraft java process
            pkill -9 -f java
        done
    done
done
