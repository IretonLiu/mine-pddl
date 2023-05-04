from typing import List, Dict
from pddl.domain import Domain
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.pddl_types.base_pddl_types import AgentType
from pddl.functions import InventoryFunction

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
        self,
        agent: AgentType,
        items: Dict[str, NamedItemType],
        blocks: Dict[str, NamedBlockType],
    ):
        output = "(:objects\n"

        output += f"\t{agent.name} - {agent.type_name}\n"

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

    def construct_initial_state(
        self,
        agent: AgentType,
        items: Dict[str, NamedItemType],
        blocks: Dict[str, NamedBlockType],
    ):
        # for each state variable, loop through predicates and functions
        output_list = []

        # process agent
        for predicate in agent.predicates.values():
            output_list.append(predicate.to_problem(agent.name))

        for function in agent.functions.values():
            # special case
            if isinstance(function, InventoryFunction):
                for item in items:
                    # items is a dict, so item is the key
                    if item.in_inventory:
                        output_list.append(
                            function.to_problem(
                                agent.name, label=item, quantity=item.quantity)
                        )
                    else:
                        output_list.append(
                            function.to_problem(
                                agent.name, label=item, quantity=0)
                        )
            else:
                output_list.append(function.to_problem(agent.name))

        # process items, blocks
        to_process = [items, blocks]
        for proc in to_process:
            for key in proc:
                # entity is a NamedBlockType or NamedItemType
                for i, entity in enumerate(proc[key]):
                    # process the predicates
                    for predicate in entity.predicates.values():
                        output_list.append(
                            predicate.to_problem(f"{entity.name}{i}")
                        )

                    # process the functions
                    for function in entity.functions.values():
                        output_list.append(
                            function.to_problem(
                                f"{entity.name}{i}")
                        )

        output = "(:init\n\t"
        output += "\n\t".join(output_list)
        output += "\n)"
        return output

    def to_pddl(
        self,
        agent: AgentType,
        items: Dict[str, NamedItemType],
        blocks: Dict[str, NamedBlockType],
    ):
        pddl = f"(define (problem {self.name})\n"
        pddl += f"\t(:domain {self.domain.name})\n"
        pddl += f"{self.construct_objects(agent, items, blocks)}\n"
        pddl += f"{self.construct_initial_state(agent, items, blocks)}"

        return pddl + ")"
