from typing import List, Dict, Any, Tuple
import pddl.pddl_types.special_pddl_types as special_pddl_types

# Helper functions for propositionalising the numerical pddls
def create_int_pddl_types(type_names: List[str], obs_range: Tuple[int, int, int], max_stack: int = 64) -> Dict[str, List[special_pddl_types.IntType]]:
    """
    Create the pddl types for the int type
    :param type_name: the name of the type
    :param min_val: the minimum value of the type
    :param max_val: the maximum value of the type
    :return: the pddl types string
    """

    int_types = {}
    for type_name in type_names:
        if type_name == 'count':
            int_types[type_name] = [special_pddl_types.IntType(type_name[0]+str(i)) for i in range(max_stack+1)]
        elif type_name == 'position':
            max_range = max(obs_range)
            int_types[type_name] = [special_pddl_types.IntType(type_name[0]+str(i)) for i in range(-max_range//2, max_range//2+1)]

    return int_types

