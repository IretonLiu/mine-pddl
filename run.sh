python src/main.py \
    --generate-pddl \
    --pddl-type numerical \
    --world-config worlds/Climb_Place_Easy.yaml \
    --domain-name test_domain \
    --problem-name test_problem \
    --domain-file problems/our/test_d_num.pddl \
    --problem-file problems/our/test_p_num.pddl \
    --max-inventory-stack 64 \
    --observation-range "(16, 16, 16)"