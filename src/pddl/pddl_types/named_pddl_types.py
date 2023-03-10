from .base_pddl_types import *


class NamedItemType(ItemType):
    def __init__(self, name: str, variation: str = None, quantity: int = None):
        super().__init__()
        self.name = name
        self.variation = variation
        self.quantity = quantity  # only used if Minecraft has grouped items together


class NamedBlockType(BlockType):
    def __init__(self, name: str):
        super().__init__()
        self.name = name
