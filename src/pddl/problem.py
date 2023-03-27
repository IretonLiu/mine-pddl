from typing import List, Dict
from pddl.domain import Domain
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType

# (define (problem <title>)
#     (:domain <domain-name>)
#     (:objects
#         <object-list>
#     )

#     (:init
#         <predicates>
#     )
#     (:goal
#         <predicates>
#     )
# )


class Problem:
    def __init__(
        self,
        name: str,
        domain: Domain,
        objects: List = [],
        init: List = [],
        goal: List = [],
    ):
        self.name = name
        self.domain = domain
        self.objects = objects
        self.init = init
        self.goal = goal

    def initialize_problem(self):
        for function in self.domain.functions:
            self.init.append(function.var_name)

    def construct_objects(
        self, items: Dict[str, NamedItemType], blocks: Dict[str, NamedBlockType]
    ):
        output = "(:objects\n"

        # loop through the keys of items and blocks
        for d in [blocks, items]:
            for key in d:
                # loop through each of the values
                temp = ""
                for i, value in enumerate(d[key]):
                    # include a number in the name so we can uniquely identify the item/object

                    temp += f"{value.name}{i} "
                temp += f"- {key}"

                # add the temp string to the object string
                output += f"\t{temp}\n"

        return output + ")"

    def to_pddl(
        self, items: Dict[str, NamedItemType], blocks: Dict[str, NamedBlockType]
    ):
        pddl = f"(define (problem {self.name})\n"
        pddl += f"\t(:domain {self.domain.name})\n"
        pddl += f"{self.construct_objects(items, blocks)}\n"

        return pddl
