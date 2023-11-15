from typing import List

from pddl.predicates import AreSequentialPredicate


# helper function for generating the intitial sequential predicates in the problem file
def generate_initial_seq_predicates(int_type_objects: List[str]):
    output = [] 
    for i in range(len(int_type_objects) - 1):
       output.append(f"{AreSequentialPredicate.to_precondition(int_type_objects[i], int_type_objects[i+1])}")
    return output

