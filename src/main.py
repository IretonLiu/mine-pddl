import handlers.entities as handlers
from helpers import execution_helper, yaml_helper
from helpers.observation_helpers import *
from helpers.video_helper import VideoHelper
import minedojo
from pddl.actions import *
from pddl.domain import Domain
from pddl.functions import *
from pddl.problem import Problem
from argument_parser import get_args_parser
import time

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


def main(args):
    # todo: process the agent's inventory - will go into the items dict

    world_config = yaml_helper.load_yaml("worlds/example.yaml")

    max_inventory_stack = 64
    ranges = (8, 4, 8)
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
        image_size=(1024, 1024),
        world_seed="Enter the Nether",
        start_position=dict(x=0.5, y=4, z=0.5, yaw=0, pitch=0),
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

    env.env.env.env.env._sim_spec._obs_handlers.append(
        handlers.EntityObservation(ranges)
    )

    # create the items in the world

    video_helper = VideoHelper(args.video_save_path)

    obs = env.reset()
    item_commands = yaml_helper.yaml_items_to_cmd(world_config["items"])
    for cmd in item_commands:
        env.execute_cmd(cmd)


    for i in range(10):
        obs, reward, done, info = env.step(env.action_space.no_op())

    video_helper.save_image(obs["rgb"])
    items, agent = extract_entities(obs)
    blocks = extract_blocks(obs)
    inventory = extract_inventory(obs, items, agent)
    domain = Domain("first_world", max_inventory_stack)

    domain.to_pddl(
        items,
        blocks,
        file_path="./problems/our/domain_prop3.pddl",
        goal=world_config["goal"],
    )

    problem = Problem(
        "first_world_problem",
        domain,
        ranges,
        max_inventory_stack,
    )

    problem.to_pddl(
        agent,
        items,
        blocks,
        goal_yaml=world_config["goal"],
        file_path="./problems/our/problem_prop3.pddl",
    )

    print(obs["entities"])
    # timer for 6 minutes
    # TODO: REmove this :)
    start_time = time.time()
    while True:
        # if the time difference is greater than 5 minutes
        if time.time() - start_time >= 1000:
            break
        continue

    print(obs["entities"])
    # action_sequence = execution_helper.read_plan("./problems/our/plan.pddl")
    action_sequence = [
        "move-south",
        "move-south",
        "place-obsidian",
        "move-north",
        "move-north",
        "move-north",
        "move-north",
        "move-south",
        "move-south",
        "move-south",
        "move-south",
        "break-obsidian",
        "move-north",
        "move-north",
        "move-north",
        "move-north",
    ]
    for action_str in action_sequence:
        # get the action vector
        action = execution_helper.get_action_from_str(
            action_str, agent=agent, env=env, inventory=inventory
        )
        obs, reward, done, info = env.step(action)
        env.execute_cmd("/entitydata @e[type=item] {Age:-32768}")
        for i in range(5):
            obs, reward, done, info = env.step(env.action_space.no_op())

        # update the observations we are working with
        video_helper.save_image(obs["rgb"])
        items, agent = extract_entities(obs)
        blocks = extract_blocks(obs)
        inventory = extract_inventory(obs, items, agent)

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
    else:
        main(args)


"""
entity simpleTypes of interest to use a s a filter (read from Types.xsd)

for inventory:
ItemType
StoneTypes
WoodTypes
FlowerTypes
"""
