python src/main.py \
    --generate-pddl \
    --pddl-type propositional \
    --world-config worlds/example.yaml \
    --domain-name test_domain \
    --problem-name test_problem \
    --domain-file problems/our/test_d.pddl \
    --problem-file problems/our/test_p.pddl \
    --max-inventory-stack 64 \
    --observation-range "(8, 6, 8)"