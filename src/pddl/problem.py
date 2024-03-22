from typing import Dict, List, Optional, Tuple

import numpy as np
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
    BlockPresentPredicate,
    GoalAchievedPredicate,
    IsAnyBlockAtPositionPredicate,
    IsAnyItemAtPositionPredicate,
    ItemPresentPredicate,
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
        lifted_representation: bool = False,
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
        self.lifted_representation = lifted_representation

        # these are only going to be used for "position" objects (propositional pddl)
        # and for setting the is-empty-at-position predicates (propositional pddl)
        self.min_position: Optional[int] = None
        self.max_position: Optional[int] = None

    def set_position_bounds(
        self, agent: AgentType, agent_position_override: Optional[Dict[str, int]] = None
    ) -> None:
        # see if there is a position override
        if agent_position_override is None:
            agent_position_override = {}
            agent_position_override["x"] = agent.functions[XPositionFunction].value
            agent_position_override["y"] = agent.functions[YPositionFunction].value
            agent_position_override["z"] = agent.functions[ZPositionFunction].value

        # we need to find the largest positive position and the smallest negative position
        # this will be used to determine the range of positions to include in the problem
        min_shifted_position = min(
            agent_position_override["x"] - self.obs_range[0] // 2,
            agent_position_override["y"] - self.obs_range[1] // 2,
            agent_position_override["z"] - self.obs_range[2] // 2,
        )
        max_shifted_position = max(
            agent_position_override["x"] + self.obs_range[0] // 2,
            agent_position_override["y"] + self.obs_range[1] // 2,
            agent_position_override["z"] + self.obs_range[2] // 2,
        )

        self.min_position = int(np.floor(min_shifted_position)) - 1
        self.max_position = int(np.ceil(max_shifted_position)) + 1

    def construct_objects(
        self,
        agent: AgentType,
        items: Dict[str, List[NamedItemType]],
        blocks: Dict[str, List[NamedBlockType]],
    ):
        # agent_position_override is used when the starting position of the agent has been modified by yaml
        # in this case, we still want the world to be centred at the agent's spawn position, so we pass that through as an override,
        # since the agent object has had its position updated

        output = "(:objects\n"

        output += f"\t{agent.name} - {agent.type_name}\n"

        # loop through the keys of items and blocks
        for key in blocks.keys() | items.keys():
            # construct the object string for both the item and block version of this type

            total_occurances = 0
            if key in blocks:
                total_occurances += len(blocks[key])
            if key in items:
                total_occurances += len(items[key])

            # add in extra objects to account for the inventory contents being placed in the world
            # we only need to account for blocks, since we cannot drop an item (yet)
            inventory_quantity = 0
            if key in items:
                for item in items[key]:
                    if item.in_inventory:
                        inventory_quantity += item.quantity

            # include an object (with a number) for each occurance of the item/block
            item_objects = [f"{key}{i}" for i in range(total_occurances)]
            block_objects = [
                f"{key}-block{i}" for i in range(total_occurances + inventory_quantity)
            ]

            # add in the object type
            item_objects.extend(["-", key])
            block_objects.extend(["-", f"{key}-block"])

            # add the both strings to the object string
            output += f"\t{' '.join(item_objects)}\n"
            output += f"\t{' '.join(block_objects)}\n"

        if self.use_propositional:
            # add the position objects
            self.postition_objects = []
            self.count_objects = []

            assert self.min_position is not None and self.max_position is not None

            if not self.lifted_representation:
                # do not add the position object definition if we are using lifted representation - they are constants in the domain
                output += "\t"
            for i in range(
                self.min_position,
                self.max_position + 1,
            ):  # add a buffer of 1 to either side of the position range
                if not self.lifted_representation:
                    output += f"{PositionType.construct_problem_object(i)} "
                self.postition_objects.append(PositionType.construct_problem_object(i))

            if not self.lifted_representation:
                output += f"- {PositionType.type_name}\n"

            # add the count objects
            if not self.lifted_representation:
                # do not add the count object definition if we are using lifted representation - they are constants in the domain
                output += "\t"
            for i in range(self.max_inventory_stack + 1):
                if not self.lifted_representation:
                    output += f"{CountType.construct_problem_object(i)} "
                self.count_objects.append(CountType.construct_problem_object(i))

            if not self.lifted_representation:
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

            if self.lifted_representation:
                # if we are using propositional pddl, we need to process the is-empty-at-position predicate
                # so we create a 3D grid representing the emptiness of the positions
                # and as we process the items and blocks, we will update the grid
                assert self.min_position is not None and self.max_position is not None
                extent = self.max_position - self.min_position + 1
                ITEM_VALUE = 1
                BLOCK_VALUE = 2
                occupancy_grid = np.zeros((extent, extent, extent))

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

                # account for a block of that type being present, but not specified in the items
                for key in blocks:
                    if key not in items:
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
                    position = int(np.floor(agent.functions[XPositionFunction].value))
                elif isinstance(predicate, AtYLocationPredicate):
                    position = int(np.floor(agent.functions[YPositionFunction].value))
                elif isinstance(predicate, AtZLocationPredicate):
                    position = int(np.floor(agent.functions[ZPositionFunction].value))
                output_list.append(
                    predicate.to_precondition(
                        agent.name, PositionType.construct_problem_object(int(position))
                    )
                )
            else:
                # this is general to both propositional and numerical pddl
                temp = predicate.to_problem(agent.name)
                if not self.lifted_representation or (
                    self.lifted_representation and ("(not" not in temp)
                ):
                    output_list.append(temp)

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

                    # account for a block of that type being present, but not specified in the items
                    for key in blocks:
                        if key not in items:
                            output_list.append(
                                function.to_problem(agent.name, label=key, quantity=0)
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
                                    np.floor(entity.functions[XPositionFunction].value)
                                )
                            elif isinstance(predicate, AtYLocationPredicate):
                                position = int(
                                    np.floor(entity.functions[YPositionFunction].value)
                                )
                            elif isinstance(predicate, AtZLocationPredicate):
                                position = int(
                                    np.floor(entity.functions[ZPositionFunction].value)
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
                            temp = predicate.to_problem(f"{name}{j}")
                            if not self.lifted_representation or (
                                self.lifted_representation and ("(not" not in temp)
                            ):
                                output_list.append(temp)

                    # process the functions - for numerical
                    if not self.use_propositional:
                        for function in entity.functions.values():
                            output_list.append(function.to_problem(f"{name}{j}"))

                    # update the emptiness grid - this has "continue" statements, so keep at the end of the for loop
                    if self.use_propositional and self.lifted_representation:
                        assert (
                            self.min_position is not None
                            and self.max_position is not None
                        )

                        # check if the entity is present in the world
                        if isinstance(entity, NamedBlockType) and (
                            entity.predicates[BlockPresentPredicate] is None
                            or not entity.predicates[BlockPresentPredicate].value
                        ):
                            continue
                        elif isinstance(entity, NamedItemType) and (
                            entity.predicates[ItemPresentPredicate] is None
                            or not entity.predicates[ItemPresentPredicate].value
                        ):
                            continue

                        position = (
                            int(np.floor(entity.functions[XPositionFunction].value))
                            - self.min_position,
                            int(np.floor(entity.functions[YPositionFunction].value))
                            - self.min_position,
                            int(np.floor(entity.functions[ZPositionFunction].value))
                            - self.min_position,
                        )
                        occupancy_grid[position] = BLOCK_VALUE if i == 0 else ITEM_VALUE

        # process the emptiness grid
        if self.use_propositional and self.lifted_representation:
            assert self.min_position is not None and self.max_position is not None

            for i in range(extent):
                for j in range(extent):
                    for k in range(extent):
                        block_predicate_str = (
                            IsAnyBlockAtPositionPredicate.to_precondition(
                                PositionType.construct_problem_object(
                                    i + self.min_position
                                ),
                                PositionType.construct_problem_object(
                                    j + self.min_position
                                ),
                                PositionType.construct_problem_object(
                                    k + self.min_position
                                ),
                            )
                        )
                        item_predicate_str = (
                            IsAnyItemAtPositionPredicate.to_precondition(
                                PositionType.construct_problem_object(
                                    i + self.min_position
                                ),
                                PositionType.construct_problem_object(
                                    j + self.min_position
                                ),
                                PositionType.construct_problem_object(
                                    k + self.min_position
                                ),
                            )
                        )

                        if occupancy_grid[i, j, k] == 0:
                            # output_list.append(pddl_not(block_predicate_str))
                            # output_list.append(pddl_not(item_predicate_str))
                            pass  # we don't want (not pred)
                        elif occupancy_grid[i, j, k] == BLOCK_VALUE:
                            output_list.append(block_predicate_str)
                            # output_list.append(pddl_not(item_predicate_str))
                        elif occupancy_grid[i, j, k] == ITEM_VALUE:
                            output_list.append(item_predicate_str)
                            # output_list.append(pddl_not(block_predicate_str))

        # TODO: fix fomatting
        output = "(:init\n\t"
        output += "\n\t".join(output_list)
        output += "\n)"
        return output

    def construct_goal(self, agent: AgentType):
        # goal_yaml is a dict of lists of dicts
        output = "(:goal"
        output += f"\n\t(and {GoalAchievedPredicate.to_precondition(agent.name)})\n\t\t"
        output += "\n)"
        return output

    def to_pddl(
        self,
        agent,
        items: Dict[str, List[NamedItemType]],
        blocks: Dict[str, List[NamedBlockType]],
        file_path: str,
        agent_position_override: Optional[
            Dict[str, int]
        ] = None,  # see self.construct_objects comment for more info
    ):
        # set the position bounds
        if self.use_propositional:
            self.set_position_bounds(agent, agent_position_override)

        pddl = f"(define (problem {self.name})\n"
        pddl += f"\t(:domain {self.domain.name})\n"
        pddl += f"{self.construct_objects(agent, items, blocks)}\n"
        pddl += f"{self.construct_initial_state(agent, items, blocks)}\n"
        pddl += f"{self.construct_goal(agent)}\n"
        pddl += ")"
        with open(file_path, "w") as file:
            file.write(pddl)

        return pddl
