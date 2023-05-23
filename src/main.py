import pickle

import handlers.entities as handlers
from helpers import execution_helper, json_helper
from helpers.observation_helpers import *
import minedojo
import numpy as np
from pddl.actions import *
from pddl.domain import Domain
from pddl.functions import *
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.problem import Problem

"""
- get inventory thing working
- block hits info
- visualise plan
- check plan works
- some final confidition to check to see if the plan is successful
- if something went wrong, give idea what went wrong
- collect extra information like number of steps taken to reach success (as json obj)
"""


# todo: process the agent's inventory - will go into the items dict

world_json = json_helper.load_json("worlds/example.json")
# print(world_json)
# print(json_helper.json_blocks_to_xml_str(world_json["blocks"]))
voxel_size = dict(xmin=-10, ymin=-2, zmin=-10, xmax=10, ymax=2, zmax=10)

env = minedojo.make(
    "open-ended",
    image_size=(1024, 1024),
    world_seed="Enter the Nether",
    start_position=dict(x=0.5, y=4, z=0.5, yaw=0, pitch=0),
    use_voxel=True,
    # spawn_mobs=False,
    voxel_size=voxel_size,
    drawing_str=f"""{json_helper.json_blocks_to_xml_str(world_json["blocks"])}""",
    initial_inventory=json_helper.json_inventory_to_inventory_item(
        world_json["inventory"]
    ),
    generate_world_type=world_json["world_type"],
    break_speed_multiplier=1000,
    allow_mob_spawn=False,
)

ranges = (10, 10, 10)
env.env.env.env.env._sim_spec._obs_handlers.append(handlers.EntityObservation(ranges))

# create the items in the world



obs = env.reset()
item_commands = json_helper.json_items_to_cmd(world_json["items"])
for cmd in item_commands:
    env.execute_cmd(cmd)

for i in range(10):
    obs, reward, done, info = env.step(env.action_space.no_op())
# voxels = obs["voxels"]
# entities = obs["entities"]
# inventory = obs["inventory"]

items, agent = extract_entities(obs)
blocks = extract_blocks(obs)
inventory = extract_inventory(obs, items, agent)


domain = Domain("first_world")
print(domain.to_pddl(items, blocks, file_path="./problems/our/domain4.pddl"))

problem = Problem("first_world_problem", domain, )

goal_string = "(:goal (>= (agent-num-oak-log steve) 1))"
print(problem.to_pddl(agent, items, blocks, goal_json=world_json['goal'], file_path="./problems/our/problem4.pddl"))

# action_sequence = execution_helper.read_plan("./problems/our/plan.pddl") 
# for action_str in action_sequence:
#     action = execution_helper.get_action_from_str(action_str, inventory, env=env)
#     obs, reward, done, info = env.step(action)

for i in range(3):
    obs, reward, done, info = env.step(env.action_space.no_op())

# items, agent = extract_entities(obs)
# blocks = extract_blocks(obs)
# inventory = extract_inventory(obs, items, agent)

print("plan successful: ", execution_helper.check_goal_state(obs, voxel_size, world_json["goal"]))

while True:
     # env.spawn_mobs("sheep", [1, 1, 1])
     action = env.action_space.no_op()    # 8-len vector
    #  act5ion[5] = 3
     # action = execution_helper.get_action_from_str(action_str, inventory, env=env)

     obs, reward, done, info = env.step(action)

#     continue
# file = open("obs.pkl", "rb")
# obs = pickle.load(file)
# file.close()



"""
entity simpleTypes of interest to use a s a filter (read from Types.xsd)

for inventory:
ItemType
StoneTypes
WoodTypes
FlowerTypes
"""
