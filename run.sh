python src/main.py \
    --generate-pddl \
    --pddl-type propositional \
    --world-config task-worlds/Move_to_Location/Move_to_Location_Easy.yaml \
    --domain-name test_domain \
    --problem-name test_problem \
    --domain-file problems/tasks/Move_to_Location/Easy/propositional/d.pddl \
    --problem-file problems/tasks/Move_to_Location/Easy/propositional/p.pddl \
    --max-inventory-stack 5 \
    --observation-range "(8, 4, 8)" 