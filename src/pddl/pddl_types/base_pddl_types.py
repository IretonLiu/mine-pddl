from typing import List

from pddl.functions import *
from pddl.predicates import Predicate


class ObjectType:
    def __init__(self):
        self.name = 'object'
        self.functions = []
        self.predicates = []


class LocatableType(ObjectType):
    def __init__(self):
        super().__init__()
        self.type_name = 'locatable'
        self.name = 'l'
        self.functions.append(PositionFunction(self))


class AgentType(LocatableType):
    def __init__(self):
        super().__init__()
        self.type_name = 'agent'
        self.name = 'ag'
        self.functions.append(InventoryFunction())
        self.predicates.append(Predicate('agent-alive', ["ag - agent"]))


class ItemType(LocatableType):
    def __init__(self):
        super().__init__()
        self.name = 'item'
        self.predicates.append(Predicate('present', ["i - item"]))


class BlockType(LocatableType):
    def __init__(self):
        super().__init__()
        self.name = 'block'
        self.predicates.append(Predicate('block-present', ["b - block"]))


class DestructibleBlockType(BlockType):
    def __init__(self):
        super().__init__()
        self.name = 'destructible-block'
        self.functions.append(BlockHitsFunction())


class BedrockType(BlockType):
    def __init__(self):
        super().__init__()
        self.name = 'bedrock'

# (:types
# 	locatable - object
# 	agent item block - locatable
# 	bedrock destructible-block - block
# 	obsidian-block - destructible-block
# 	wool diamond stick diamond-pickaxe apple potato rabbit orchid-flower daisy-flower flint coal iron-ore iron-ingot netherportal flint-and-steel - item
# )
