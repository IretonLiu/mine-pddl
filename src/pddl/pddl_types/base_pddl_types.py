from typing import List
from pddl.pddl_types.types_names import TypeName
from pddl.functions import *
from pddl.predicates import *

# TODO: check if items despawn + how to turn off
# TODO: pass in name instead of hardcoding
name_dict = {"object": "object"}


class ObjectType:
    type_name = TypeName.OBJECT_TYPE_NAME.value

    def __init__(self):
        self.name = "obj"
        self.functions = {}  # TODO: Make functions a dictionary
        self.predicates = {}

    def to_string(self):
        return f"{self.name} - {self.type_name}"


class LocatableType(ObjectType):
    type_name = TypeName.LOCATABLE_TYPE_NAME.value

    def __init__(self):
        super().__init__()
        self.var_name = "l"
        self.functions[XPositionFunction] = XPositionFunction()
        self.functions[YPositionFunction] = YPositionFunction()
        self.functions[ZPositionFunction] = ZPositionFunction()

        # self.functions.append(PositionFunction(self, LocatableType.type_name))


class AgentType(LocatableType):
    type_name = TypeName.AGENT_TYPE_NAME.value

    def __init__(self):
        super().__init__()
        self.var_name = "ag"
        self.name = "steve"
        self.functions[InventoryFunction] = InventoryFunction()
        self.predicates[AgentAlivePredicate] = AgentAlivePredicate()


class ItemType(LocatableType):
    type_name = TypeName.ITEM_TYPE_NAME.value

    def __init__(self):
        super().__init__()
        self.var_name = "itm"
        self.predicates[ItemPresentPredicate] = ItemPresentPredicate()


class BlockType(LocatableType):
    type_name = TypeName.BLOCK_TYPE_NAME.value

    def __init__(self):
        super().__init__()
        self.var_name = "blk"
        self.predicates[BlockPresentPredicate] = BlockPresentPredicate()


class DestructibleBlockType(BlockType):
    type_name = TypeName.DESTRUCTIBLE_BLOCK_TYPE_NAME.value

    def __init__(self):
        super().__init__()
        self.var_name = "dblk"
        self.functions[BlockHitsFunction] = BlockHitsFunction()


class BedrockType(BlockType):
    type_name = TypeName.BEDROCK_TYPE_NAME.value

    def __init__(self):
        self.var_name = "bed"
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
