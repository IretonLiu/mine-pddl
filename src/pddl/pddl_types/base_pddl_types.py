from typing import List

from pddl.functions import *
from pddl.predicates import Predicate

# TODO: check if items despawn + how to turn off

class ObjectType:
    type_name = 'object'
    def __init__(self):
        # self.type_name = 'object'
        self.functions = []
        self.predicates = []


class LocatableType(ObjectType):
    type_name='locatable'
    def __init__(self):
        super().__init__()
        self.name = 'l'
        self.functions.append(PositionFunction(self))


class AgentType(LocatableType):
    type_name='agent'
    def __init__(self):
        super().__init__()
        self.name = 'ag'
        self.functions.append(InventoryFunction(self))
        self.predicates.append(Predicate('agent-alive', ["ag - agent"]))


class ItemType(LocatableType):
    type_name = 'item'
    def __init__(self):
        super().__init__()
        self.predicates.append(Predicate('present', ["i - item"]))


class BlockType(LocatableType):
    type_name = 'block'
    def __init__(self):
        super().__init__()
        self.predicates.append(Predicate('block-present', ["b - block"]))


class DestructibleBlockType(BlockType):
    type_name = 'destructible-block'
    def __init__(self):
        super().__init__()
        self.functions.append(BlockHitsFunction(self))


class BedrockType(BlockType):
    type_name = 'bedrock'
    def __init__(self):
        super().__init__()

# (:types
# 	locatable - object
# 	agent item block - locatable
# 	bedrock destructible-block - block
# 	obsidian-block - destructible-block
# 	wool diamond stick diamond-pickaxe apple potato rabbit orchid-flower daisy-flower flint coal iron-ore iron-ingot netherportal flint-and-steel - item
# )

"""
(:action drop-diamond
 :parameters (?ag - agent ?i - diamond)
 :precondition (and (>= (agent-num-diamond ?ag) 1)
                    (not (present ?i)))
 :effect (and (present ?i)
              (assign (x ?i) (x ?ag))
              (assign (y ?i) (+ (y ?ag) 1))
              (assign (z ?i) (z ?ag))
              (decrease (agent-num-diamond ?ag) 1)
         )
)

"""