from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.functions import *
import numpy as np


def get_valid_inventory_types():
    import xml.etree.ElementTree as ET

    tree = ET.parse("src/Types.xsd")
    root = tree.getroot()

    # list of the types we are interested in for the inventory
    valid_parent_types = ["ItemType", "StoneTypes", "WoodTypes", "FlowerTypes"]

    # create a dictionary to store the parent types and their variations
    valid_inventory_types = dict.fromkeys(valid_parent_types, [])

    # loop through the high-level types
    for child in root:
        # if the parent type is of interest, carry on
        if child.attrib["name"] in valid_parent_types:
            for c in child:
                if "restriction" in c.tag:
                    for enumeration in c:
                        valid_inventory_types[child.attrib["name"]].append(
                            enumeration.attrib["value"]
                        )

    return valid_inventory_types


def get_invalid_inventory_types():
    import xml.etree.ElementTree as ET

    tree = ET.parse("src/Types.xsd")
    root = tree.getroot()

    # list of the types we are interested in for the inventory
    invalid_parent_types = ["EntityTypes"]

    # create a dictionary to store the parent types and their variations
    invalid_inventory_types = dict.fromkeys(invalid_parent_types, [])

    # loop through the high-level types
    for child in root:
        # if the parent type is of interest, carry on
        if child.attrib["name"] in invalid_parent_types:
            for c in child:
                if "restriction" in c.tag:
                    for enumeration in c:
                        invalid_inventory_types[child.attrib["name"]].append(
                            enumeration.attrib["value"]
                        )

    return invalid_inventory_types


def extract_blocks(obs):
    """
    pass in the observation returned from minedojo
    returns a dict of blocks (key is their block name, value is a NamedBlockType)
    """
    entities = obs["entities"]

    # extra player from entities
    player_pos = None
    for i, entity in enumerate(entities):
        if entity["name"] == "MineDojoAgent0":
            player_pos = (entity["x"], entity["y"], entity["z"])
            entities.pop(i)
            break

    voxels = obs["voxels"]["block_name"]
    blocks = {}
    # process the voxel data to obtain the aboslute position of each block
    for x in range(len(voxels)):
        for y in range(len(voxels[x])):
            for z in range(len(voxels[x][y])):
                block_name = voxels[x][y][z]

                # Assume observation is centred at player
                absolute_pos = (
                    np.array([x, y, z])
                    - np.array(voxels.shape) // 2
                    + np.array(player_pos)
                )

                named_block = NamedBlockType(block_name)

                for function in named_block.functions:
                    if isinstance(function, PositionFunction):
                        function.set_position(absolute_pos)
                        break

                if block_name not in blocks:
                    blocks[named_block.name] = [named_block]
                else:
                    blocks[named_block.name].append(named_block)

    return blocks


def extract_items(obs):
    """
    pass in the observation returned from minedojo
    returns a dict of items (key is their item name, value is a NamedItemType)
    """

    # determine what corresponds to a valid inventory type
    invalid_inventory_types = get_invalid_inventory_types()

    entities = obs["entities"]

    items = {}
    # process the entity data to get all the items
    for entity in entities:
        # only consider valid types
        # if entity["name"] not in valid_inventory_types.keys():
        #     continue

        # store the name and variation (if applicable)

        if (
            entity["name"] not in invalid_inventory_types["EntityTypes"]
            and entity["name"] != "MineDojoAgent0"
        ):
            named_item = NamedItemType(
                item_name=entity["name"],
                variation=entity["variant"] if "variant" in entity else None,
                quantity=entity["quantity"],
            )

            # set the position of the block
            position = (int(entity["x"]), int(entity["y"]), int(entity["z"]))
            for function in named_item.functions:
                if isinstance(function, PositionFunction):
                    function.set_position(position)
                    break

            # store the items
            if named_item.name not in items:
                items[named_item.name] = [named_item]
            else:
                items[named_item.name].append(named_item)

    return items
