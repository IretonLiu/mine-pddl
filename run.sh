python src/main.py \
    --generate-pddl \
    --pddl-type numerical \
    --world-config worlds/Climb_Place_Easy.yaml \
    --domain-name Climb_Place_Easy_Domain \
    --problem-name Climb_Place_Easy_Problem \
    --domain-file problems/our/Climb_Place_Easy_domain_num.pddl \
    --problem-file problems/our/Climb_Place_Easy_problem_num.pddl \
    --max-inventory-stack 64 \
    --observation-range "(8, 6, 8)"