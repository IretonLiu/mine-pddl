#!/bin/bash

declare -a jobs=(
    Cut_Tree,Hard
    Build_Cross,Hard
    Build_Wall,Hard
    Build_Well,Hard
    Build_Shape,Hard
    Collect_Build_Shape,Hard
    Collect_Build_Shape,Medium
)

# define the base file paths to the files
yaml_base_path="./task-worlds"
plan_base_path="./human-solutions-pddl"

OLDIFS=$IFS
IFS=','
for i in "${jobs[@]}"; do
    set -- $i
    # $1 is the task name
    # $2 is the difficulty level
    task="${1}"
    difficulty="${2}"

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
IFS=$OLDIFS
