python src/main.py \
    --generate-pddl \
    --pddl-type numerical \
    --world-config worlds/Place_Wood_Easy.yaml \
    --domain-name test_domain \
    --problem-name test_problem \
    --domain-file problems/our/wood_d_e_num.pddl \
    --problem-file problems/our/wood_p_e_num.pddl \
    --max-inventory-stack 64 \
    --observation-range "(5, 4, 5)"