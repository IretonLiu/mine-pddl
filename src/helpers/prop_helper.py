from typing import List, Dict, Any, Tuple

from humanfriendly.terminal import output
from pddl.predicates import *
import pddl.pddl_types.special_pddl_types as special_pddl_types
from pddl.predicates import AreSequentialPredicate

# helper function for generating the intitial sequential predicates in the problem file
def generate_initial_seq_predicates(int_type_objects: List[str]):
    output = [] 
    for i in range(len(int_type_objects) - 1):
       output.append(f"{AreSequentialPredicate.to_precondition(int_type_objects[i], int_type_objects[i+1])}")
    return output

