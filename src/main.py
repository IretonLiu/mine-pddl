# import minedojo
import json_helper
import handlers.entities as handlers
import numpy as np
import pickle
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.functions import *

# world_json = json_helper.load_json("worlds/example.json")
# print(world_json)
# print(json_helper.json_blocks_to_xml_str(world_json["blocks"]))


# env = minedojo.make(
#     "open-ended",
#     image_size=(1024, 1024),
#     world_seed="Enter the Nether",
#     start_position=dict(x=-260, y=86, z=173, yaw=0, pitch=0),
#     use_voxel=True,
#     voxel_size=dict(xmin=-4, ymin=-4, zmin=-4, xmax=4, ymax=4, zmax=4),
#     drawing_str=f"""{json_helper.json_blocks_to_xml_str(world_json["blocks"])}"""
# )

# ranges = (5, 5, 5)
# env.env.env.env.env._sim_spec._obs_handlers.append(
#     handlers.EntityObservation(ranges))

# # TODO: implement handler for observationfromnearbyentities
# obs = env.reset()

# voxels = obs['voxels']
# entities = obs['entities']

# done = False
# while True:
#     env.spawn_mobs("sheep", [1, 1, 1])
#     action = env.action_space.no_op()    # 8-len vector
#     obs, reward, done, info = env.step(action)

#     continue
file = open("obs.pkl", "rb")
obs = pickle.load(file)
file.close()

entities = obs['entities']

# extra player from entities
player_pos = None
for i, entity in enumerate(entities):
    if (entity['name'] == 'MineDojoAgent0'):
        player_pos = (entity['x'], entity['y'], entity['z'])
        entities.pop(i)
        break

voxels = obs['voxels']['block_name']
blocks = {}
# process the voxel data to obtain the aboslute position of each block
for x in range(len(voxels)):
    for y in range(len(voxels[x])):
        for z in range(len(voxels[x][y])):
            block_name = voxels[x][y][z]

            # Assume observation is centered at player
            absolute_pos = np.array(
                [x, y, z]) - np.array(voxels.shape)//2 + np.array(player_pos)

            named_block = NamedBlockType(block_name)

            for function in named_block.functions:
                if isinstance(function, PositionFunction):
                    function.set_position(absolute_pos)
                    break

            if block_name not in blocks:
                blocks[block_name] = [named_block]
            else:
                blocks[block_name].append(named_block)

print(obs)
