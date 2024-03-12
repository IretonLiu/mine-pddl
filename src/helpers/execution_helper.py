from typing import Dict, List, Optional

import numpy as np
from helpers.utils import rename
from minedojo.sim.wrappers.ar_nn.ar_nn_wrapper import ARNNWrapper
from pddl.functions import XPositionFunction, YPositionFunction, ZPositionFunction
from pddl.pddl_types.base_pddl_types import AgentType

# TODO: If we ever implement drop, we need to remember that dropped items don't get the NBT tag for presistance


def read_plan(plan_path: str):
    """
    Read the plan from the pddl file
    Each line has the following format: (<action name> <action args>)
    """

    action_sequence = []
    with open(plan_path, "r") as file:
        for line in file:
            if line[0] == "(":
                # this line is a valid action
                # i.e. in the format (<action name> <action args>)

                # get the action name only - get rid of the brackets and action args (which are only meaningful to the planner)
                action_name = line[1:].split(" ")[0].strip("()").strip()

                action_sequence.append(action_name)

                # if we have the checkgoal action, we can stop reading the plan any further
                # todo: carry on reading the plan, which would allow for optimality/efficiency checking
                if action_name == "checkgoal":
                    break

    return action_sequence


def move_command(
    env,
    action_args: List[str],
    agent: AgentType,
    jump_dir: Optional[int] = 0,
):
    """
    Move the agent in the environment by using teleport command
    """

    direction = action_args[-1]
    command = ""
    if direction == "south":
        command = "/tp @p {} {} {}".format(
            agent.functions[XPositionFunction].value,
            agent.functions[YPositionFunction].value + jump_dir,
            agent.functions[ZPositionFunction].value + 1,
        )
    elif direction == "north":
        command = "/tp @p {} {} {}".format(
            agent.functions[XPositionFunction].value,
            agent.functions[YPositionFunction].value + jump_dir,
            agent.functions[ZPositionFunction].value - 1,
        )
    elif direction == "east":
        command = "/tp @p {} {} {}".format(
            agent.functions[XPositionFunction].value + 1,
            agent.functions[YPositionFunction].value + jump_dir,
            agent.functions[ZPositionFunction].value,
        )
    elif direction == "west":
        command = "/tp @p {} {} {}".format(
            agent.functions[XPositionFunction].value - 1,
            agent.functions[YPositionFunction].value + jump_dir,
            agent.functions[ZPositionFunction].value,
        )

    env.execute_cmd(command)


def place_block(env, action_args: List[str], agent: AgentType) -> None:
    """
    set the desired block to be one in front and one below the player
    """
    block_name = action_args[1]
    direction = action_args[-1]

    # place the block in the world
    # example command: /setblock <x> <y> <z> <new block name> [variation] [oldBlockHandling:default=replace] [dataTag (for new block)]
    if direction == "south":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value + 1,
            block_name,
        )
    elif direction == "north":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value - 1,
            block_name,
        )
    elif direction == "east":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value + 1,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value,
            block_name,
        )
    elif direction == "west":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value - 1,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value,
            block_name,
        )
    else:
        raise ValueError(f"Invalid direction {direction}")

    env.execute_cmd(command)

    # decrement this block from the agent's inventory
    # https://www.digminecraft.com/game_commands/clear_command.php
    # example command: /clear [targets] [item] [data - variant] [maxCount] [dataTag]
    # example: /clear @a tnt 0 10
    command = f"/clear @a {block_name} 0 1"
    env.execute_cmd(command)


def break_block(env, action_args: List[str], agent: AgentType) -> None:
    """
    break a block in front of the agent
    """
    block_name = action_args[1]
    direction = action_args[-1]

    # https://www.digminecraft.com/game_commands/setblock_command.php
    if direction == "south":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value + 1,
            "air",
        )
    elif direction == "north":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value - 1,
            "air",
        )
    elif direction == "east":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value + 1,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value,
            "air",
        )
    elif direction == "west":
        command = "/setblock {} {} {} {}".format(
            agent.functions[XPositionFunction].value - 1,
            agent.functions[YPositionFunction].value,
            agent.functions[ZPositionFunction].value,
            "air",
        )
    else:
        raise ValueError(f"Invalid direction {direction}")

    env.execute_cmd(command)

    # decrement this block from the agent's inventory
    # https://www.digminecraft.com/game_commands/clear_command.php
    # example command: /clear [targets] [item] [data - variant] [maxCount] [dataTag]
    # example: /clear @a tnt 0 10
    command = f"/give @p {block_name}"
    env.execute_cmd(command)


def jump(env, action_args: List[str], direction: int, agent):
    """
    just a wrapper for the move command
    direction up = tp one up and one in front
    direction down = tp one behind and one down
    """
    move_command(env=env, action_args=action_args, agent=agent, jump_dir=direction)


def get_action_from_str(
    action: str,
    agent: AgentType,
    env: ARNNWrapper,
    curr_dir: str,
    inventory: Optional[Dict] = None,
):
    """
    Formulate the action vector from the pddl action string
    """
    action_vector = env.action_space.no_op()
    # split by first hyphen
    # main action is the first part
    # any items or blocks are the second part
    # the direction is the last part
    # direction is between -180 and 180
    dir_to_yaw = {
        "north": -180,
        "south": 0,
        "east": -90,
        "west": 90,
    }

    # action name convention: {action_name_no_hyphen}-{args}-{direction}
    # only the checkgoal action does not have a direction
    action_args = action.split("-")
    action_name = action_args[0]
    action_dir = action_args[-1]

    if action_name == "checkgoal":
        # check goal does nothing for the python actions, so we don't do anything here
        return action_vector, curr_dir

    yaw = dir_to_yaw[action_dir]

    if action_dir != curr_dir:
        exec_command = f"/tp @p ~ ~ ~ {yaw} 0"
        env.execute_cmd(exec_command)
        curr_dir = action_dir

    if "move" in action_name:
        move_command(env, action_args, agent)
    elif "jumpup" in action_name:
        jump(env, action_args, agent=agent, direction=1)
    elif "jumpdown" in action_name:
        jump(env, action_args, agent=agent, direction=-1)
    elif action_name == "place":
        # eg action is "place-obsidian"
        # action_args will be "obsidian"
        place_block(env, action_args, agent)
    elif action_name == "break":
        break_block(env, action_args, agent)
    elif action_name == "drop":
        assert inventory is not None
        action_vector[5] = 2
        for i, name in enumerate(inventory["name"]):
            if name == action_args:
                action_vector[7] = i
                break

    return action_vector, curr_dir


def check_goal_state(obs, voxel_size, goal):
    # get the agent, block, and inventory from the goal
    agent = goal["agent"][0] if "agent" in goal else None
    blocks = goal["blocks"] if "blocks" in goal else []
    inventory = goal["inventory"] if "inventory" in goal else []

    # get the position of the agent in the world
    agent_pos = obs["location_stats"]["pos"]
    agent_pos = np.floor(agent_pos).astype(int)

    # confirm the agent is in the correct position
    if agent is not None:
        agent_goal_position = agent["position"]
        agent_goal_position = np.array(
            [
                int(np.floor(float(agent_goal_position["x"]))),
                int(np.floor(float(agent_goal_position["y"]))),
                int(np.floor(float(agent_goal_position["z"]))),
            ]
        )
        if not np.all(agent_pos == agent_goal_position):
            return False

    # loop over all the blocks in the goal and check if they are present
    for block in blocks:
        block_position = block["position"]

        relative_position = (
            np.array(
                [
                    int(np.floor(float(block_position["x"]))),
                    int(np.floor(float(block_position["y"]))),
                    int(np.floor(float(block_position["z"]))),
                ]
            )
            - agent_pos
        )
        voxel_position = np.array(
            [
                (voxel_size["xmax"] - voxel_size["xmin"]) / 2,
                (voxel_size["ymax"] - voxel_size["ymin"]) / 2,
                (voxel_size["zmax"] - voxel_size["zmin"]) / 2,
            ]
        )

        relative_position += np.ceil(voxel_position).astype(int)

        actual = obs["voxels"]["block_name"][
            relative_position[0], relative_position[1], relative_position[2]
        ]
        # rename actual block if neccessary
        if actual in rename:
            actual = rename[actual]

        if actual != block["type"]:
            return False

    # loop over all the inventory items in the goal and check if they are present
    for inv_item in inventory:
        item_in_true_inventory = False
        for i, name in enumerate(obs["inventory"]["name"]):
            if int(inv_item["quantity"]) == 0:
                # if the quantity is 0, we don't care about the item
                item_in_true_inventory = True
                break

            if name == inv_item["type"]:
                item_in_true_inventory = True
                if float(obs["inventory"]["quantity"][i]) < float(inv_item["quantity"]):
                    return False

                # break if we have found the item we are looking for
                break

        # if we get here, we have either
        # 1) found the item in the inventory and checked the quantity is correct
        # 2) not found the item in the inventory
        if not item_in_true_inventory:
            return False

    return True


def set_birds_eye_view(env):
    exec_command = "/gamemode spectator"
    env.execute_cmd(exec_command)
    exec_command = "/tp @p ~ 15 ~ 0 90"
    env.execute_cmd(exec_command)


def move_agent_to_location(env, x_pos, y_pos, z_pos):
    exec_command = f"/tp @p {x_pos} {y_pos} {z_pos}"
    env.execute_cmd(exec_command)
