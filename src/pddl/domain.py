from typing import Dict
import inspect
import pddl.pddl_types.base_pddl_types as base_pddl_types
from collections import defaultdict

# (:types
# 	locatable - object
# 	agent item block - locatable
# 	bedrock destructible-block - block
# 	obsidian-block - destructible-block
# 	wool diamond stick diamond-pickaxe apple potato rabbit orchid-flower daisy-flower flint coal iron-ore iron-ingot netherportal flint-and-steel - item
# )

# (:predicates
# 	 (present ?i - item)
# 	 (block-present ?b - block)
# 	 (agent-alive ?ag - agent)
# )

class Domain:
    def __init__(self):
        # self.name = name
        # self.obs = obs
        self.types = None
        self.constants = []
        self.predicates = []
        self.functions = []
        self.actions = []
        self.requirements = []

    def construct_types(self, item_types, block_types):
        
        types_dict = defaultdict(list)
        # print all the classes in the pddl.pddl_types.base_pddl_types module without classes from their own imports
        for name, cls in inspect.getmembers(base_pddl_types):
            if inspect.isclass(cls) and cls.__module__ == base_pddl_types.__name__:
                # get the parent class of the obj if it has one
                parent = cls.__bases__[0] if cls.__bases__[0].__name__ != 'object' else None   
                
                if parent:
                    types_dict[getattr(parent, "type_name", None)].append(getattr(cls, "type_name", None))

        for key in item_types:
            types_dict['item'].append(key)
        

        for key in block_types:
            # TODO: check if block is destructible

            types_dict[getattr(base_pddl_types.DestructibleBlockType, 'type_name')].append(key)

        # convert types_dict to string
        types_str = '(types:\n'
        for key in types_dict:
            types_str+= f'\t'
            for value in types_dict[key]:
                types_str += f'{value} '
            types_str += f'- {key}\n'
        types_str += ')'
        print(types_str)
        
                
