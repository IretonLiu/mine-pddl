from typing import Dict, List, Tuple

from helpers.prop_helper import generate_initial_seq_predicates
from pddl.domain import Domain
from pddl.functions import (
    InventoryFunction,
    XPositionFunction,
    YPositionFunction,
    ZPositionFunction,
)
from pddl.pddl_types.base_pddl_types import AgentType
from pddl.pddl_types.named_pddl_types import NamedBlockType, NamedItemType
from pddl.pddl_types.special_pddl_types import CountType, PositionType
from pddl.predicates import (
    AgentHasNItemsPredicate,
    AtLocationPredicate,
    AtXLocationPredicate,
    AtYLocationPredicate,
    AtZLocationPredicate,
    GoalAchievedPredicate,
)

"""
(define (problem <title>)
    (:domain <domain-name>)
    (:objects
        <object-list>
    )

    (:init
        <predicates>
    )
    (:goal
        <predicates>
    )
)
"""


class Problem:
    def __init__(
        self,
        name: str,
        domain: Domain,
        obs_range: Tuple[int, int, int],
        max_inventory_stack: int,
        use_propositional: bool,
        objects: List = [],
        init: List = [],
        goal: List = [],
    ):
        self.name = name
        self.domain = domain
        self.objects = objects
        self.goal = goal
        self.obs_range = obs_range
        self.max_inventory_stack = max_inventory_stack
        self.use_propositional = use_propositional

    def construct_objects(
        self,
        agent: AgentType,
        items: Dict[str, List[NamedItemType]],
        blocks: Dict[str, List[NamedBlockType]],
    ):
        output = "(:objects\n"

        output += f"\t{agent.name} - {agent.type_name}\n"

        # loop through the keys of items and blocks
        for i, d in enumerate([blocks, items]):
            for key in d:
                # loop through each of the values
                temp = ""
                for j, value in enumerate(d[key]):
                    # include a number in the name so we can uniquely identify the item/object

                    temp += f"{value.name}"
                    temp += "-block" if i == 0 else ""
                    temp += f"{j} "

                temp += f"- {key}"
                temp += "-block" if i == 0 else ""
                # add the temp string to the object string
                output += f"\t{temp}\n"

        if self.use_propositional:
            # add the position objects
            self.postition_objects = []
            self.count_objects = []
            max_range = max(self.obs_range)
            output += "\t"
            for i in range(
                -max_range // 2 - 1, max_range // 2 + 1 + 1
            ):  # add a buffer of 1 to either side of the position range
                # todo: could double the range, but that would add in quite a bit of complexity
                output += f"{PositionType.construct_problem_object(i)} "
                self.postition_objects.append(PositionType.construct_problem_object(i))

            output += f"- {PositionType.type_name}\n"

            # add the count objects
            output += "\t"
            for i in range(self.max_inventory_stack + 1):
                output += f"{CountType.construct_problem_object(i)} "
                self.count_objects.append(CountType.construct_problem_object(i))
            output += f"- {CountType.type_name}\n"

        return output + ")"

    def construct_initial_state(
        self,
        agent: AgentType,
        items: Dict[str, List[NamedItemType]],
        blocks: Dict[str, List[NamedBlockType]],
    ):
        # for each state variable, loop through predicates and functions
        output_list = []

        if self.use_propositional:
            # process int type objects
            output_list.extend(generate_initial_seq_predicates(self.postition_objects))
            output_list.extend(generate_initial_seq_predicates(self.count_objects))

        # process agent
        for predicate in agent.predicates.values():
            if isinstance(predicate, AgentHasNItemsPredicate):
                # this will only be called for propositional pddl
                for key in items:
                    item = items[key]
                    for i in item:
                        if i.in_inventory:
                            output_list.append(
                                predicate.to_precondition(
                                    agent.name,
                                    n=CountType.construct_problem_object(i.quantity),
                                    item_type=key,
                                )
                            )
                        else:
                            output_list.append(
                                predicate.to_precondition(
                                    agent.name,
                                    n=CountType.construct_problem_object(0),
                                    item_type=key,
                                )
                            )
            elif isinstance(predicate, AtLocationPredicate):
                # this will also only be called for propositional pddl
                position = float("inf")
                if isinstance(predicate, AtXLocationPredicate):
                    position = int(agent.functions[XPositionFunction].value)
                elif isinstance(predicate, AtYLocationPredicate):
                    position = int(agent.functions[YPositionFunction].value)
                elif isinstance(predicate, AtZLocationPredicate):
                    position = int(agent.functions[ZPositionFunction].value)
                output_list.append(
                    predicate.to_precondition(
                        agent.name, PositionType.construct_problem_object(int(position))
                    )
                )
            else:
                # this is general to both propositional and numerical pddl
                output_list.append(predicate.to_problem(agent.name))

        if not self.use_propositional:
            for function in agent.functions.values():
                # special case
                if isinstance(function, InventoryFunction):
                    for key in items:
                        # items is a dict, so item is the key
                        item = items[key]
                        for i in item:
                            if i.in_inventory:
                                output_list.append(
                                    function.to_problem(
                                        agent.name, label=key, quantity=i.quantity
                                    )
                                )
                            else:
                                output_list.append(
                                    function.to_problem(
                                        agent.name, label=key, quantity=0
                                    )
                                )
                else:
                    output_list.append(function.to_problem(agent.name))

        # process items, blocks
        to_process = [blocks, items]
        for i, proc in enumerate(to_process):
            for key in proc:
                # entity is a NamedBlockType or NamedItemType
                for j, entity in enumerate(proc[key]):
                    name = entity.name + "-block" if i == 0 else entity.name
                    # process the predicates
                    for predicate in entity.predicates.values():
                        if isinstance(predicate, AtLocationPredicate):
                            # this will also only be called for propositional pddl
                            position = float("inf")
                            if isinstance(predicate, AtXLocationPredicate):
                                position = int(
                                    entity.functions[XPositionFunction].value
                                )
                            elif isinstance(predicate, AtYLocationPredicate):
                                position = int(
                                    entity.functions[YPositionFunction].value
                                )
                            elif isinstance(predicate, AtZLocationPredicate):
                                position = int(
                                    entity.functions[ZPositionFunction].value
                                )
                            output_list.append(
                                predicate.to_precondition(
                                    f"{name}{j}",
                                    PositionType.construct_problem_object(
                                        int(position)
                                    ),
                                )
                            )
                        else:
                            # this is general to both propositional and numerical pddl
                            output_list.append(predicate.to_problem(f"{name}{j}"))

                    # process the functions - for numerical
                    if not self.use_propositional:
                        for function in entity.functions.values():
                            output_list.append(function.to_problem(f"{name}{j}"))

        # TODO: fix fomatting
        output = "(:init\n\t"
        output += "\n\t".join(output_list)
        output += "\n)"
        return output

    def construct_goal(self, agent: AgentType):
        # goal_yaml is a dict of lists of dicts
        output = "(:goal"
        output += f"\n\t(and {GoalAchievedPredicate.to_problem(agent.name)})\n\t\t"
        output += "\n))"
        return output

    def to_pddl(
        self,
        agent,
        items: Dict[str, List[NamedItemType]],
        blocks: Dict[str, List[NamedBlockType]],
        file_path: str,
    ):
        pddl = f"(define (problem {self.name})\n"
        pddl += f"\t(:domain {self.domain.name})\n"
        pddl += f"{self.construct_objects(agent, items, blocks)}\n"
        pddl += f"{self.construct_initial_state(agent, items, blocks)}\n"
        pddl += f"{self.construct_goal(agent)}\n"
        pddl += ")"
        with open(file_path, "w") as file:
            file.write(pddl)

        return pddl
