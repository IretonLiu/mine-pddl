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

def move_command(env, direction: str):
    """
    Move the agent in the environment by using teleport command
    """
    if direction == "north":
        env.execute_cmd("/tp @p ~ ~ ~1")
    elif direction == "south":
        env.execute_cmd("/tp @p ~ ~ ~-1")
    elif direction == "east":
        env.execute_cmd("/tp @p ~1 ~ ~")
    elif direction == "west":
        env.execute_cmd("/tp @p ~-1 ~ ~") 
    

def get_action_from_str(action: str, inventory, env):
    """
    Formulate the action vector from the pddl action string
    """
    action_vector = env.action_space.no_op()
    # split by first hyphen
    action_name, action_args = action.split("-", 1)
    if action_name == "move":
        move_command(env, action_args)
    
    return action_vector



    


