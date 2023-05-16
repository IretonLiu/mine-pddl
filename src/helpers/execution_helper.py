import numpy as np


def get_action_from_str(action: str, inventory=None):
    """
    Formulate the action vector from the pddl action string
    """
    action_vector = np.zeros(8)
    # split by first hyphen
    action_name, action_args = action.split("-", 1)
    if action_name == "move":
        if action_args == "north":
            action_vector[0] = 1
        elif action_args == "south":
            action_vector[0] = 2
        elif action_args == "east":
            action_vector[1] = 1
        elif action_args == "west":
            action_vector[1] = 2
    
    return action_vector



    


