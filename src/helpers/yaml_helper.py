from typing import Dict, List, Optional, Tuple

import yaml
from minedojo.sim.inventory import InventoryItem


def load_yaml(yaml_file: str) -> dict:
    """
    Loads a YAML file
    """
    with open(yaml_file, "r") as f:
        return yaml.safe_load(f)


def yaml_cuboids_to_xml_str(cuboids: list[dict]) -> str:
    """
    Converts a list of cuboids to an xml string
    """
    xml_str = ""
    for cuboid in cuboids:
        xml_str += f"""
        <DrawCuboid x1={cuboid['position']['x1']} x2={cuboid['position']['x2']} y1={cuboid['position']['y1']} y2={cuboid['position']['y2']} z1={cuboid['position']['z1']} z2={cuboid['position']['z2']} type={cuboid['type']}'/>
        """
    return xml_str


def yaml_blocks_to_xml_str(blocks: list[dict]) -> str:
    """
    Converts a list of blocks to an xml string
    """
    xml_str = ""
    for block in blocks:
        xml_str += f"""
        <DrawBlock x=\"{block['position']['x']}\" y=\"{block['position']['y']}\" z=\"{block['position']['z']}\" type=\"{block['type']}\"/>
        """
    return xml_str


def yaml_inventory_to_inventory_item(inventory: list[dict]) -> Optional[List]:
    """
    Converts a list of inventory items to an inventory item list
    """
    inventory_item_list = []
    for i, item in enumerate(inventory):
        if item["type"] == "air" or item["quantity"] == 0:
            continue
        inventory_item_list.append(
            InventoryItem(
                slot=i,
                name=item["type"],
                variant=item["variant"] if "variant" in item else None,
                quantity=item["quantity"],
            )
        )
    return None if len(inventory_item_list) == 0 else inventory_item_list


def yaml_items_to_cmd(items: list[dict]) -> list:
    """
    take in a list of YAML item objects and returns a list of strings, which are the minecraft commands for generating them in the world
    """

    # https://www.digminecraft.com/game_commands/summon_command.php
    # /summon Item ~ ~ ~ {Item:{id:"minecraft:diamond",Count:1}}

    commands = []
    for item in items:
        cmd = '/summon Item {} {} {} {{Item:{{id:"minecraft:{}",Count:{}}}}}'.format(
            item["position"]["x"],
            item["position"]["y"],
            item["position"]["z"],
            item["type"],
            item["quantity"],
        )
        commands.append(cmd)

    return commands


def yaml_find_max_range(items, blocks) -> Dict[str, Tuple[int, int]]:
    """
    Find the max range of the world
    """
    axes = ["x", "y", "z"]
    output = {}

    for axis in axes:
        min_pos = float("inf")
        max_pos = -float("inf")
        for item in items:
            position = float(item["position"][axis])
            min_pos = min(position, min_pos)
            max_pos = max(position, max_pos)
        for block in blocks:
            position = float(block["position"][axis])
            min_pos = min(position, min_pos)
            max_pos = max(position, max_pos)

        output[axis] = (min_pos, max_pos)
    return output


if __name__ == "__main__":
    import os

    tasks = os.listdir("./task-worlds/worlds")

    for difficulty in ["Easy", "Medium", "Hard"]:
        print(f"Difficulty: {difficulty}")
        ranges = {
            "x": (float("inf"), -float("inf")),
            "y": (float("inf"), -float("inf")),
            "z": (float("inf"), -float("inf")),
        }
        for task in tasks:
            filename = f"./task-worlds/worlds/{task}/{task}_{difficulty}.yaml"
            if not os.path.isfile(filename):
                continue
            yaml_file = load_yaml(filename)
            output = yaml_find_max_range(
                yaml_file["items"] if "items" in yaml_file else [],
                yaml_file["blocks"] if "blocks" in yaml_file else [],
            )

            for key in output.keys():
                ranges[key] = (
                    min(ranges[key][0], output[key][0]),
                    max(ranges[key][1], output[key][1]),
                )

        print(ranges)


# TODO : error handling
