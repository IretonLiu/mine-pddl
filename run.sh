# generate pddl
python src/main.py \
    --generate-pddl \
    --pddl-type propositional \
    --grounded-actions \
    --world-config "./data/worlds/Place_Wood/Place_Wood_Easy.yaml" \
    --domain-name domain \
    --problem-name problem \
    --domain-file "./data/domain.pddl" \
    --problem-file "./data/problem.pddl" \
    --max-inventory-stack 64 \
    --observation-range "(13, 9, 13)"

exit

# execute plan
# note that the observation range can be arbitrarily large here
# note that the variables are used to construct file paths, and the project structure may be different
yaml_file="./task-worlds/Build_Wall/Build_Wall_Hard.yaml"
plan_file="./human-solutions-pddl/Build_Wall/Build_Wall_Hard.pddl"
plan_name=$(basename $plan_file ".pddl")
python src/main.py \
    --execute-plan \
    --pddl-type "propositional" \
    --world-config "${yaml_file}" \
    --plan-file "${plan_file}" \
    --video-save-path "Plans/human_solutions/no_path/${plan_name}" \
    --video-name "${plan_name}" \
    --observation-range "(81, 41, 81)" # this is larger than in any task, so it should be fine
