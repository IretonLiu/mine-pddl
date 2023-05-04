from .base_pddl_types import *


# todo: formalise the convention of having self.name for both of these types
class NamedItemType(ItemType):
    type_name = "named_item"

    def __init__(
        self, item_name: str = "default", variation: str = None, quantity: int = None, in_inventory: bool = False
    ):
        super().__init__()
        self.name = f"{variation}-{item_name}" if variation else item_name
        self.name = self.name.replace(" ", "_")
        self.variation = variation
        self.quantity = quantity  # only used if Minecraft has grouped items together
        self.in_inventory = in_inventory


class NamedBlockType(DestructibleBlockType):
    def __init__(self, block_name: str = "default"):
        super().__init__()
        self.name = block_name
        self.name = self.name.replace(" ", "_")
