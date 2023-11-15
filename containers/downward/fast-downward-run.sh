BENCHMARKS=./problems
docker run --entrypoint /bin/bash -v $BENCHMARKS:/workspace/downward/benchmarks -it aibasel/downward

./fast-downward.py --alias lama-first ./benchmarks/our/domain_prop3.pddl ./benchmarks/our/problem_prop3.pddl