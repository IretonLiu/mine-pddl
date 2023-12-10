#!/bin/zsh

declare -a task_array=(
    "Build_Log_Cabin" "Move_to_Location" "Place_Wood" "PDDL Files" "Cut_Tree" "Gather_Multiple_Wood" "Climb_Place" "Bridge" "Build_Well" 
    "Farm_Wheat" "Craft_Item" "Build_Wall" "Pickup_and_Place" "Grow_Tree" "Collect_Build_Shape" "Gather_Wood" "Build_Shape" "Build_Cross" "Pickup_Diamond"
)
declare -a difficulty_array=("Easy" "Medium" "Hard")
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
declare -a pddl_types=("numerical" "propositional")

for task in ./task-worlds/worlds/*; do
    task=$(basename $task)
    echo "========== Processing task ${task} =========="
    for difficulty in ${difficulty_array[@]}; do 
        for pddl_type in ${pddl_types[@]}; do 


            task_folder="./task-worlds/worlds/${task}/${task}_${difficulty}"
            yaml_file="${task_folder}.yaml"

            obsrange=${obsrange_array[$difficulty]}

            if [ $task = "Build_Log_Cabin" ]; then
                obsrange=${logcabin_obsrange_array[$difficulty]}
            elif [ $task = "Cut_Tree" ]; then
                obsrange=${cuttree_obsrange_array[$difficulty]}
            fi
            
            echo "Generating PDDL for ${task}_${difficulty} for pddl type ${pddl_type}..."

            # check if the yaml file exists
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
