from base_pddl_types import *


class NamedItemType(ItemType):
    def __init__(self, name: str):
        super().__init__()
        self.name = name

    def __str__(self):
        return self.name


class NamedBlockType(BlockType):
    def __init__(self, name: str):
        super().__init__()
        self.name = name

    def __str__(self):
        return self.name
