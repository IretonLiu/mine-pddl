# import json

# class WorldSpec:
#     '''
#     A class used to represent a world specification

#     '''
#     def __init__(self) -> None:
#         self.world_type = "default"
#         self.world_name = "open-ended"
#         self.voxel_observation_range = 10
#         self.blocks = []


#     def from_json(self, json_data: dict) -> None:
#         self.world_type = json_data["world_type"]
#         self.world_name = json_data["world_name"]
#         self.voxel_observation_range = json_data["voxel_observation_range"]
#         self.blocks = json_data["blocks"]

#     def to_json(self) -> dict:
#         return {
#             "world_type": self.world_type,
#             "world_name": self.world_name,
#             "voxel_observation_range": self.voxel_observation_range,
#             "blocks": self.blocks
#         }

