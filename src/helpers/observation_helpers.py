from typing import Dict, List, Tuple

import numpy as np
from pddl.functions import XPositionFunction, YPositionFunction, ZPositionFunction
from pddl.pddl_types.base_pddl_types import AgentType
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.predicates import AgentAlivePredicate, GoalAchievedPredicate

rename = {"wood": "log", "wooden planks": "planks"}


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


def get_valid_block_and_item_types():
    import xml.etree.ElementTree as ET

    tree = ET.parse("src/Types.xsd")
    root = tree.getroot()

    # list of the types we are interested in for the inventory
    valid_parent_types = [
        "ItemType",
        "BlockType",
    ]

    # create a dictionary to store the parent types and their variations
    valid_types = dict.fromkeys(valid_parent_types, [])

    # loop through the high-level types
    for child in root:
        # if the parent type is of interest, carry on
        if child.attrib["name"] in valid_parent_types:
            for c in child:
                if "restriction" in c.tag:
                    for enumeration in c:
                        valid_types[child.attrib["name"]].append(
                            enumeration.attrib["value"]
                        )

    return valid_types


def print_extracted_types_xsd(types: Dict[str, List[str]]):
    # print out the type parent name followed by the specific names under that parent
    print("The following are valid types given the overarching parent type.")
    for parent_type, child_types in types.items():
        print(f"\n{parent_type}:")
        for child_type in child_types:
            print(f"\t{child_type}")


def extract_blocks(obs, use_propositional: bool):
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
                if block_name == "air":
                    continue

                # Assume observation is centred at player
                block_name = rename[block_name] if block_name in rename else block_name
                absolute_pos = (
                    np.array([x, y, z])
                    - np.array(voxels.shape) // 2
                    + np.array(player_pos)
                )

                # skip the block if it is below ground level, i.e. y = 3 or below
                if absolute_pos[1] <= 2:
                    continue

                named_block = NamedBlockType(use_propositional, block_name)

                named_block.functions[XPositionFunction].set_value(absolute_pos[0])
                named_block.functions[YPositionFunction].set_value(absolute_pos[1])
                named_block.functions[ZPositionFunction].set_value(absolute_pos[2])

                #    elif isinstance(function, BlockHitsFunction):
                #         # todo: figure out how to get this info from the obs
                #         pass
                #     elif isinstance(function, InventoryFunction):
                #         # we do not need to process inventory now - that will be done when the PDDL is produced
                #         pass

                # assign value to the predicates
                # we are reading these items/blocks/agent from the world, so they must exist
                for predicate in named_block.predicates.values():
                    predicate.set_value(
                        True
                    )  # this is just the block-present predicate for now

                if named_block.name not in blocks:
                    blocks[named_block.name] = [named_block]
                else:
                    blocks[named_block.name].append(named_block)

    return blocks


def extract_entities(obs, use_propositional: bool) -> Tuple[Dict, AgentType]:
    """
    pass in the observation returned from minedojo
    returns a dict of items (key is their item name, value is a NamedItemType)
    """

    # determine what corresponds to a valid inventory type
    invalid_inventory_types = get_invalid_inventory_types()

    entities = obs["entities"]

    items = {}
    agent = AgentType(use_propositional)
    have_processed_agent = False
    # process the entity data to get all the items
    for entity in entities:
        # only consider valid types
        # if entity["name"] not in valid_inventory_types.keys():
        #     continue

        # store the name and variation (if applicable)
        object_to_process = None
        if (
            entity["name"] not in invalid_inventory_types["EntityTypes"]
            and entity["name"] != "MineDojoAgent0"
        ):
            named_item = NamedItemType(
                use_propositional,
                item_name=entity["name"],
                variation=entity["variant"] if "variant" in entity else "",
                quantity=int(entity["quantity"]),
            )

            # store the items
            if named_item.name not in items:
                items[named_item.name] = [named_item]
            else:
                items[named_item.name].append(named_item)

            # create a reference so we don't duplicate code
            object_to_process = named_item

            # assign value to the predicates
            # we are reading these items/blocks/agent from the world, so they must exist
            for predicate in object_to_process.predicates.values():
                predicate.set_value(
                    True
                )  # this is just the item-present predicate for now

        elif entity["name"] == "MineDojoAgent0":
            # we are working with the agent now
            have_processed_agent = True

            agent.predicates[AgentAlivePredicate].set_value(True)
            agent.predicates[GoalAchievedPredicate].set_value(False)

            # create a reference so we don't duplicate code
            object_to_process = agent

        if object_to_process is None:
            raise Exception("object_to_process is None")

        # set the position of the object
        position = ((entity["x"]), (entity["y"]), (entity["z"]))
        object_to_process.functions[XPositionFunction].set_value(position[0])
        object_to_process.functions[YPositionFunction].set_value(position[1])
        object_to_process.functions[ZPositionFunction].set_value(position[2])

        # elif isinstance(function, BlockHitsFunction):
        #     # will never have block_hits for an entity
        #     pass
        # elif isinstance(function, InventoryFunction):
        #     # we do not need to process inventory now - that will be done when the PDDL is produced
        #     pass

    assert have_processed_agent, "Agent not found in observation"
    return items, agent


def extract_inventory(obs, items, agent, use_propositional: bool):
    """
    pass in the inventory of the agent into the list of items
    """
    inventory = obs["inventory"]

    for i, name in enumerate(inventory["name"]):
        # only consider valid types
        if name == "air":
            continue
        named_item = NamedItemType(
            use_propositional,
            item_name=name,
            variation=inventory["variant"][i],
            quantity=int(inventory["quantity"][i]),
            in_inventory=True,
        )

        named_item.functions[XPositionFunction].set_value(
            agent.functions[XPositionFunction].value
        )
        named_item.functions[YPositionFunction].set_value(
            agent.functions[YPositionFunction].value
        )
        named_item.functions[ZPositionFunction].set_value(
            agent.functions[ZPositionFunction].value
        )

        # store the items
        if named_item.name not in items:
            items[named_item.name] = [named_item]
        else:
            items[named_item.name].append(named_item)

    return inventory
