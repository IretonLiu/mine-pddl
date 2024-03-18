# generate pddl
python src/main.py \
    --generate-pddl \
    --pddl-type propositional \
    --for-lifted-planner \
    --world-config worlds/example.yaml \
    --domain-name test_domain \
    --problem-name test_problem \
    --domain-file problems/d.pddl \
    --problem-file problems/p.pddl \
    --max-inventory-stack 5 \
    --observation-range "(5, 5, 5)" 

exit

# execute plan
# note that the observation range can be arbitrarily large here
# note that the variables are used to construct file paths, and the project structure may be different
pddl_type="propositional"
task="Place_Wood"
difficulty="Easy"
plan_name="place_wood-easy"
plan_number="5"
python src/main.py \
    --execute-plan \
    --pddl-type ${pddl_type} \
    --world-config "task-worlds/${task}/${task}_${difficulty}.yaml" \
    --plan-file "Plans/${pddl_type}/${plan_name}/${plan_name}-${plan_number}" \
    --video-save-path "Plans/${pddl_type}/${plan_name}" \
    --video-name "${plan_name}-${plan_number}" \
    --observation-range "(13, 9, 13)"
