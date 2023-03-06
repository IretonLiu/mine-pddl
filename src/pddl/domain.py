from typing import Dict
from pddl.pddl_types.base_pddl_types import PDDLTypeTree


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
    def __init__(self, name, obs: Dict = None, actions=None):
        self.name = name
        self.obs = obs
        self.types = []
        self.constants = []
        self.predicates = []
        self.functions = []
        self.actions = []
        self.requirements = []

    # TODO: pddl functions can be a python class?
    def functions_from_inventory(self, obs=None):
        template = '(agent-num-{} ?ag - agent)'

        for item in obs['inventory']:
            item_name = item['name'].replace(' ', '-')
            self.functions.append(template.format(item_name))

    def find_functions_from_type(self, type_name: str):
        functions = []
        for function in self.functions:
            if function.object_type == type_name:
                functions.append(function)

    def define_types_from_string(self, types_dict):
        self.types = PDDLTypeTree('object')
        self.types.construct_tree(types_dict)

        # {
        #     object: [locatable],
        #     locatable: [agent, item, block],
        #     block: [bedrock, destructible-block],
        #     destructible-block: [obsidian-block],
        #     item: [wool, diamond, stick, diamond-pickaxe, apple, potato, rabbit, orchid-flower, daisy-flower, flint, coal, iron-ore, iron-ingot, netherportal, flint-and -steel]
        # }
