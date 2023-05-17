import numpy as np

def read_plan(plan_path: str):
    """
    Read the plan from the pddl file
    Each line has the following format: <action no.>: (<action name> <action args>)
    """
    action_sequence = []
    with open(plan_path, "r") as file:
        for line in file:
            if line[0] == ";":
                continue
            action_sequence.append(line.split(":")[1].strip().split(" ")[0].strip("("))
    return action_sequence


def get_action_from_str(action: str, inventory, env):
    """
    Formulate the action vector from the pddl action string
    """
    action_vector = env.action_space.no_op()
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



    


