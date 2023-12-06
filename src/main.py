import os

import handlers.entities as handlers
import minedojo  # type: ignore
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

# todo: unify the domain and problem views items and blocks (everything needs to be present in both items and blocks)
# todo: also add in extra problem-file pddl objects for all the inventory contents
# todo: fix the predicates always being initialised to true


def generate_or_execute_pddl(args):
    # todo: process the agent's inventory - will go into the items dict

    world_config = yaml_helper.load_yaml(args.world_config)

    max_inventory_stack = args.max_inventory_stack
    ranges = args.observation_range
    voxel_size = dict(
        xmin=-ranges[0] // 2,
        ymin=-ranges[1] // 2,
        zmin=-ranges[2] // 2,
        xmax=ranges[0] // 2,
        ymax=ranges[1] // 2,
        zmax=ranges[2] // 2,
    )

    env = minedojo.make(
        args.world_name,
        image_size=args.window_size,
        world_seed=args.world_seed,
        start_position=args.agent_start_position,
        use_voxel=True,
        # spawn_mobs=False,
        voxel_size=voxel_size,
        drawing_str=f"""{yaml_helper.yaml_blocks_to_xml_str(world_config["blocks"])}""",
        initial_inventory=yaml_helper.yaml_inventory_to_inventory_item(
            world_config["inventory"]
        ),
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
        )

    if args.execute_plan:
        # create the video helper
        video_helper = VideoHelper(args.video_save_path)
        video_helper.save_image(obs["rgb"])
        curr_dir = "south"
        # action_sequence = execution_helper.read_plan(args.plan_file)
        action_sequence = [
            "move-north",
            "move-north",
            "jumpup-north"
            "place-obsidian-north",
            
        ]
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

        while True:
            obs, reward, done, info = env.step(env.action_space.no_op())
            video_helper.save_image(obs["rgb"])

        print(
            "plan successful: ",
            execution_helper.check_goal_state(obs, voxel_size, world_config["goal"]),
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
