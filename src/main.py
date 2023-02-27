import minedojo
import json_helper

world_json = json_helper.load_json("worlds/example.json")
print(world_json)
print(json_helper.json_blocks_to_xml_str(world_json["blocks"]))


env = minedojo.make(
    "open-ended",
    image_size=(1024,1024),
    world_seed="Enter the Nether",
    start_position=dict(x=-260, y=86, z=173, yaw=0, pitch=0),
    use_voxel=True,
    voxel_size=dict(xmin=-4, ymin=-4, zmin=-4, xmax=4, ymax=4, zmax=4),
    drawing_str=f"""{json_helper.json_blocks_to_xml_str(world_json["blocks"])}"""
)
# TODO: implement handler for observationfromnearbyentities
obs = env.reset()
done = False
while True:
    action = env.action_space.no_op()    # 8-len vector
    obs, reward, done, info = env.step(action)
    continue
    
