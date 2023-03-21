from .base_pddl_types import *


class NamedItemType(ItemType):
    type_name = 'named_item'
    def __init__(self, item_name: str, variation: str = None, quantity: int = None):
        super().__init__()
        self.item_name = item_name
        self.variation = variation
        self.quantity = quantity  # only used if Minecraft has grouped items together


class NamedBlockType(DestructibleBlockType):
    def __init__(self, block_name: str):
        super().__init__()
        self.block_name = block_name
