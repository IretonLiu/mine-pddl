import minedojo
import json_helper
import handlers.entities as handlers
import numpy as np
import pickle
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.functions import *
from observation_helpers import (
    extract_blocks,
    extract_entities,
)
from pddl.domain import Domain
from pddl.problem import Problem

# todo: process the agent's inventory - will go into the items dict

world_json = json_helper.load_json("worlds/example.json")
print(world_json)
print(json_helper.json_blocks_to_xml_str(world_json["blocks"]))


env = minedojo.make(
    "open-ended",
    image_size=(1024, 1024),
    world_seed="Enter the Nether",
    start_position=dict(x=-260, y=86, z=173, yaw=0, pitch=0),
    use_voxel=True,
    # spawn_mobs=False,
    voxel_size=dict(xmin=-4, ymin=-4, zmin=-4, xmax=4, ymax=4, zmax=4),
    drawing_str=f"""{json_helper.json_blocks_to_xml_str(world_json["blocks"])}""",
    initial_inventory=json_helper.json_inventory_to_inventory_item(world_json["inventory"]),
)

ranges = (5, 5, 5)
env.env.env.env.env._sim_spec._obs_handlers.append(
    handlers.EntityObservation(ranges))

obs = env.reset()
voxels = obs['voxels']
entities = obs['entities']
inventory = obs["inventory"]

# done = False
# while True:
#     # env.spawn_mobs("sheep", [1, 1, 1])
#     action = env.action_space.no_op()    # 8-len vector
#     obs, reward, done, info = env.step(action)

#     continue
file = open("obs.pkl", "rb")
obs = pickle.load(file)
file.close()

items, agent = extract_entities(obs)
blocks = extract_blocks(obs)

domain = Domain("first_world")
print(domain.to_pddl(items, blocks))

problem = Problem("problem", domain)
print(problem.to_pddl(agent, items, blocks))

"""
entity simpleTypes of interest to use a s a filter (read from Types.xsd)

for inventory:
ItemType
StoneTypes
WoodTypes
FlowerTypes
"""
