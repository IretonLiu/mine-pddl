BENCHMARKS=~/mine-pddl/problems
sudo docker run --entrypoint /bin/bash -v $BENCHMARKS:/workspace/downward/benchmarks -it aibasel/downward

./fast-downward.py --alias lama-first ./benchmarks/our/domain_prop2.pddl ./benchmarks/our/problem_prop2.pddl