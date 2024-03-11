import os

import handlers.entities as handlers
import minedojo  # type: ignore
from argument_parser import agent_start_position as process_agent_start_position
from argument_parser import get_args_parser
from helpers import execution_helper, yaml_helper
from helpers.observation_helpers import (
    extract_blocks,
    extract_entities,
    extract_inventory,
    get_valid_block_and_item_types,
    print_extracted_types_xsd,
)
from helpers.video_helper import VideoHelper
from pddl.domain import Domain
from pddl.functions import XPositionFunction, YPositionFunction, ZPositionFunction
from pddl.problem import Problem

"""
- get inventory thing working
- block hits info
- visualise plan
- check plan works
- some final confidition to check to see if the plan is successful
- if something went wrong, give idea what went wrong
- collect extra information like number of steps taken to reach success (as json obj)

- get camera angle correct
- create the move and pickup actions
- remove the pickup and drop (only) actions
- 
"""

RED = "\033[31m"
GREEN = "\033[32m"
RESET = "\033[0m"


def generate_or_execute_pddl(args):
    world_config = yaml_helper.load_yaml(args.world_config)

    max_inventory_stack = args.max_inventory_stack
    ranges = args.observation_range
    voxel_size = dict(
        xmin=-(ranges[0] // 2) + (1 if ranges[0] % 2 == 0 else 0),
        ymin=-(ranges[1] // 2) + (1 if ranges[1] % 2 == 0 else 0),
        zmin=-(ranges[2] // 2) + (1 if ranges[2] % 2 == 0 else 0),
        xmax=ranges[0] // 2,
        ymax=ranges[1] // 2,
        zmax=ranges[2] // 2,
    )

    drawing_str = (
        f"""{yaml_helper.yaml_blocks_to_xml_str(world_config["blocks"])}"""
        if "blocks" in world_config
        else None
    )
    initial_inventory = (
        yaml_helper.yaml_inventory_to_inventory_item(world_config["inventory"])
        if "inventory" in world_config
        else None
    )
    env = minedojo.make(
        args.world_name,
        image_size=args.window_size,
        world_seed=args.world_seed,
        start_position=args.agent_start_position,
        use_voxel=True,
        # spawn_mobs=False,
        voxel_size=voxel_size,
        drawing_str=drawing_str,
        initial_inventory=initial_inventory,
        generate_world_type=args.world_type,
        break_speed_multiplier=1000,
        allow_mob_spawn=False,
    )

    use_propositional = args.pddl_type == "propositional"

    env.env.env.env.env._sim_spec._obs_handlers.append(
        handlers.EntityObservation(ranges)
    )

    # create the items in the world
    obs = env.reset()
    if "items" in world_config:
        item_commands = yaml_helper.yaml_items_to_cmd(world_config["items"])
        for cmd in item_commands:
            env.execute_cmd(cmd)

    # loop to allow time for the above commands to reflect in minecraft
    for i in range(10):
        obs, reward, done, info = env.step(env.action_space.no_op())

    items, agent = extract_entities(obs, use_propositional)
    blocks = extract_blocks(obs, use_propositional)
    inventory = extract_inventory(obs, items, agent, use_propositional)

    # check if the world config has the agent start position
    # this start position is an override, but we can only enforce it now, otherwise the observation would be centred at the wrong location
    # so we need to enforce it now
    agent_original_position = None
    if "agent" in world_config:
        # get the new position
        agent_start_position_overwrite = world_config["agent"][0]["position"]
        agent_start_position_overwrite = process_agent_start_position(
            f"({agent_start_position_overwrite['x']}, {agent_start_position_overwrite['y']}, {agent_start_position_overwrite['z']})"
        )

        # store the original position
        # since we are moving the agent's starting position, we need to override the agent's position in the problem pddl when generating the position objects
        agent_original_position = {
            "x": agent.functions[XPositionFunction].value,
            "y": agent.functions[YPositionFunction].value,
            "z": agent.functions[ZPositionFunction].value,
        }

        # change the agent's position - this is required for the correctness of the problem pddl
        agent.functions[XPositionFunction].set_value(
            agent_start_position_overwrite["x"]
        )
        agent.functions[YPositionFunction].set_value(
            agent_start_position_overwrite["y"]
        )
        agent.functions[ZPositionFunction].set_value(
            agent_start_position_overwrite["z"]
        )

        # move the agent to the start position - this is required for the correctness of executing the plan
        execution_helper.move_agent_to_location(
            env,
            agent_start_position_overwrite["x"],
            agent_start_position_overwrite["y"],
            agent_start_position_overwrite["z"],
        )

        # make sure the teleportation takes effect
        for i in range(5):
            obs, reward, done, info = env.step(env.action_space.no_op())

    if args.generate_pddl:
        # make sure the paths exist
        for filepath in [args.domain_file, args.problem_file]:
            # get the directory path, excluding the file name
            os.makedirs(os.path.dirname(filepath), exist_ok=True)

        # create the domain file
        domain = Domain(
            args.domain_name, max_inventory_stack, use_propositional=use_propositional
        )
        domain.to_pddl(
            items,
            blocks,
            file_path=args.domain_file,
            goal=world_config["goal"],
        )

        # create the problem file
        problem = Problem(
            args.problem_name,
            domain,
            ranges,
            max_inventory_stack,
            use_propositional=use_propositional,
        )
        problem.to_pddl(
            agent,
            items,
            blocks,
            file_path=args.problem_file,
            agent_position_override=agent_original_position,
        )

    if args.execute_plan:
        # we might have had to update the agent's position, so we need to process the updated obs
        # we couldn't do it earlier because we don't want to alter the blocks, items, and inventory for generating pddl
        items, agent = extract_entities(obs, use_propositional)
        blocks = extract_blocks(obs, use_propositional)
        inventory = extract_inventory(obs, items, agent, use_propositional)

        # create the video helper
        video_helper = VideoHelper(
            args.video_save_path,
            world_config["name"] if "name" in world_config else "unknown",
            args.domain_name,
            args.problem_name,
            args.pddl_type,
        )
        video_helper.save_image(obs["rgb"])
        curr_dir = "south"

        action_sequence = execution_helper.read_plan(args.plan_file)
        for action_str in action_sequence:
            # get the action vector
            action, curr_dir = execution_helper.get_action_from_str(
                action_str, agent=agent, env=env, inventory=inventory, curr_dir=curr_dir
            )
            obs, reward, done, info = env.step(action)
            for i in range(5):
                obs, reward, done, info = env.step(env.action_space.no_op())

            # update the video, if we are executing a plan
            video_helper.save_image(obs["rgb"])

            # update the observations we are working with
            items, agent = extract_entities(obs, use_propositional)
            blocks = extract_blocks(obs, use_propositional)
            inventory = extract_inventory(obs, items, agent, use_propositional)

        # check if the goal state has been reached BEFORE switch to birds eye view - since obs is relative to agent
        plan_successful = execution_helper.check_goal_state(
            obs, voxel_size, world_config["goal"]
        )

        execution_helper.set_birds_eye_view(env)
        for i in range(5):
            obs, reward, done, info = env.step(env.action_space.no_op())
        video_helper.save_birds_eye_view(obs["rgb"])

        print(
            f"{GREEN if plan_successful else RED}{'Goal Achieved' if plan_successful else 'Goal Not Achieved'}{RESET}"
        )

        print("Generating Video...")
        video_name = str(args.video_name)
        first = video_name.find(".")
        first = first if first != -1 else len(video_name)
        video_helper.generate_video(video_name[:first] + ".mp4")
        print("Cleaning up...")
        video_helper.clean_up()


if __name__ == "__main__":
    # parse all the command line arguments
    parser = get_args_parser()
    args = parser.parse_args()

    if args.print_valid_types:
        print_extracted_types_xsd(get_valid_block_and_item_types())
        exit()

    # check that at least one mode has been chosen
    if not any(
        [
            args.generate_pddl,
            args.generate_plan,
            args.execute_plan,
        ]
    ):
        raise ValueError(
            "Please choose at least one mode to run: set one of --generate-pddl, --generate-plan, --execute-plan"
        )

    if args.generate_plan:
        pass
    else:
        if args.generate_pddl:
            if args.pddl_type is None:
                raise ValueError("specify the type of PDDL to generate")

        generate_or_execute_pddl(args)


"""
entity simpleTypes of interest to use a s a filter (read from Types.xsd)

for inventory:
ItemType
StoneTypes
WoodTypes
FlowerTypes
"""
