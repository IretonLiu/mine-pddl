python src/main.py \
    --generate-pddl \
    --pddl-type numerical \
    --world-config worlds/example.yaml \
    --domain-name test_domain \
    --problem-name test_problem \
    --domain-file problems/d.pddl \
    --problem-file problems/p.pddl \
    --max-inventory-stack 5 \
    --observation-range "(5, 4, 5)" 