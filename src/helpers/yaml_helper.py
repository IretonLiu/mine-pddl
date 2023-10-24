from minedojo.sim.inventory import InventoryItem
import yaml


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


def yaml_inventory_to_inventory_item(inventory: list[dict]) -> list:
    """
    Converts a list of inventory items to an inventory item list
    """
    inventory_item_list = []
    for i, item in enumerate(inventory):
        inventory_item_list.append(
            InventoryItem(
                slot=i,
                name=item["name"],
                variant=item["variant"],
                quantity=item["quantity"],
            )
        )
    return inventory_item_list


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


# TODO : error handling
