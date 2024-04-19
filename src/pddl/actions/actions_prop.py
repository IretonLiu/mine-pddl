import itertools as it
from typing import Any, Dict, List, Optional

import numpy as np
from pddl.operators import pddl_and, pddl_exists, pddl_not, pddl_or
from pddl.pddl_types.special_pddl_types import CountType, PositionType
from pddl.pddl_types.types_names import TypeName
from pddl.predicates import (
    AgentAlivePredicate,
    AgentHasNItemsPredicate,
    AreSequentialPredicate,
    AtXLocationPredicate,
    AtYLocationPredicate,
    AtZLocationPredicate,
    BlockPresentPredicate,
    GoalAchievedPredicate,
    ItemPresentPredicate,
)


class Action:
    def __init__(self) -> None:
        self.name = None
        self.parameters = []
        self.preconditions = []
        self.effects = []
        self.lifted_representation = False
        self.is_grounded = False

        self.action_name = None  # this gets set in each of the subclasses
        self.param_names = {}
        self.param_types = {}

        # sentinel values for the exists_builder function
        self.PLACEHOLDER = "###"

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        self.lifted_representation = lifted_representation

    def construct_parameters(self):
        raise NotImplementedError

    def construct_preconditions(self):
        raise NotImplementedError

    def construct_effects(self):
        raise NotImplementedError

    def to_pddl(self, pddl_objects: Optional[Dict[str, List[str]]] = None) -> str:
        def generate_action_string(action_number: Optional[Any] = None) -> str:
            if action_number is None:
                action_number = ""

            self.construct_parameters()
            self.construct_preconditions()
            self.construct_effects()
            out = f"(:action {self.action_name}{action_number}\n"
            out += (
                f"\t:parameters ({self.parameters})\n" if not self.is_grounded else ""
            )
            out += f"\t:precondition {self.preconditions}\n"
            out += f"\t:effect {self.effects}\n"
            out += ")\n"
            return out

        if self.is_grounded:
            assert (
                pddl_objects is not None
            ), "pddl_objects must be provided for grounded actions"

            # generate the combinations according to the parameters
            object_list = []
            parameter_keys = list(self.param_names.keys())
            for key in parameter_keys:
                object_list.append(pddl_objects[self.param_types[key]])
            combinations = it.product(*object_list)

            overall_out = set()
            for action_num, combo in enumerate(combinations):
                # update the parameter mappings
                for i, key in enumerate(parameter_keys):
                    self.param_names[key] = combo[i]

                # generate the pddl string for this action
                out = generate_action_string(action_num)

                # add the string to a set to remove duplicates
                overall_out.add(out)

            return "\n".join(overall_out)
        else:
            return generate_action_string()

    def exists_builder(
        self,
        exists_conditions_pddl: str,
        is_block: bool,
        var_name: str,
        existential_object_key_override: Optional[str] = None,
    ) -> str:
        # optionally add in the existential conditions if we are not using a lifted representation
        # var_name is the variable name that should be printed

        # replace the placeholder with the variable name
        exists_conditions_pddl = exists_conditions_pddl.replace(
            self.PLACEHOLDER, var_name
        )

        if not self.lifted_representation:
            if is_block:
                key = TypeName.BLOCK_TYPE_NAME.value
            else:
                key = TypeName.ITEM_TYPE_NAME.value

            if existential_object_key_override is not None:
                key = existential_object_key_override

            exists_conditions_pddl = pddl_exists(
                {key: var_name},
                exists_conditions_pddl,
            )

        return exists_conditions_pddl


class Move(Action):
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"move-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_names = {
            "Agent": "?ag",
            "XPosition": "?x",
            "ZPosition": "?z",
            "XPositionStart": "?x_start",
            "XPositionEnd": "?x_end",
            "YPositionUp": "?y_up",
            "YPositionDown": "?y_down",
            "YPosition2Down": "?y_2_down",  # for standing on when we move
            "ZPositionStart": "?z_start",
            "ZPositionEnd": "?z_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "XPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "YPosition2Down": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionEnd": TypeName.POSITION_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        # depending on the direction of travel, we need to check that the end location is not occupied by a block/item
        # we will set the x_start, x_end, z_start, and z_end variables to hold the relevant arg names so we can just look them up later
        move_east_west = self.dir == "east" or self.dir == "west"
        direction_should_increase = self.dir == "south" or self.dir == "east"
        if move_east_west:
            x_start = self.param_names["XPositionStart"]
            x_end = self.param_names["XPositionEnd"]
        else:
            x_start = self.param_names["XPosition"]
            x_end = self.param_names["XPosition"]

        if not move_east_west:
            z_start = self.param_names["ZPositionStart"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            z_start = self.param_names["ZPosition"]
            z_end = self.param_names["ZPosition"]

        # todo: confirm that these orders are correct
        if direction_should_increase:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_start if move_east_west else z_start,
                x_end if move_east_west else z_end,
            )
        else:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_end if move_east_west else z_end,
                x_start if move_east_west else z_start,
            )

        block_var = "?b"
        item_var = "?i"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_names["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_names["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition2Down"], self.param_names["YPositionDown"]
            ),
            # check there is a block to stand on
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(self.PLACEHOLDER, x_end),
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPosition2Down"]
                    ),
                    AtZLocationPredicate.to_precondition(self.PLACEHOLDER, z_end),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_end),
                        # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionDown"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.ITEM_TYPE_NAME.value: item_var},
                    pddl_and(
                        f"({ItemPresentPredicate.var_name} {item_var})\n",
                        AtXLocationPredicate.to_precondition(item_var, x_end),
                        # here we only check that there is no item at the level of the agent (bottom) since items cannot float
                        # they would require a block to be placed beneath it, which is handled by the previous precondition
                        AtYLocationPredicate.to_precondition(
                            item_var, self.param_names["YPositionDown"]
                        ),
                        AtZLocationPredicate.to_precondition(item_var, z_end),
                    ),
                )
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_names["ZPositionStart"]
            end = self.param_names["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
        else:
            start = self.param_names["XPositionStart"]
            end = self.param_names["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

        self.effects = pddl_and(
            pddl_not(
                predicate_to_use.to_precondition(self.param_names["Agent"], start)
            ),
            predicate_to_use.to_precondition(self.param_names["Agent"], end),
        )


class MoveAndPickup(Action):
    def __init__(self, dir, item) -> None:
        super().__init__()
        self.dir = dir
        self.item = item
        self.action_name = f"move_and_pickup-{item}-{dir}"

        self.param_names = {
            "Agent": "?ag",
            "Item": "?i",
            "XPosition": "?x",
            "ZPosition": "?z",
            "XPositionStart": "?x_start",
            "XPositionEnd": "?x_end",
            "YPositionUp": "?y_up",
            "YPositionDown": "?y_down",
            "YPosition2Down": "?y_2_down",  # for standing on when we move
            "ZPositionStart": "?z_start",
            "ZPositionEnd": "?z_end",
            "NStart": "?n_start",
            "NEnd": "?n_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "Item": self.item,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "XPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "YPosition2Down": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "NStart": TypeName.COUNT_TYPE_NAME.value,
            "NEnd": TypeName.COUNT_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        # depending on the direction of travel, we need to check that the end location is not occupied by a block/item
        # we will set the x_start, x_end, z_start, and z_end variables to hold the relevant arg names so we can just look them up later
        move_east_west = self.dir == "east" or self.dir == "west"
        direction_should_increase = self.dir == "south" or self.dir == "east"
        if move_east_west:
            x_start = self.param_names["XPositionStart"]
            x_end = self.param_names["XPositionEnd"]
        else:
            x_start = self.param_names["XPosition"]
            x_end = self.param_names["XPosition"]

        if not move_east_west:
            z_start = self.param_names["ZPositionStart"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            z_start = self.param_names["ZPosition"]
            z_end = self.param_names["ZPosition"]

        # todo: confirm that these orders are correct
        if direction_should_increase:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_start if move_east_west else z_start,
                x_end if move_east_west else z_end,
            )
        else:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_end if move_east_west else z_end,
                x_start if move_east_west else z_start,
            )

        block_var = "?b"
        # item_var = "?i"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_names["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_names["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition2Down"], self.param_names["YPositionDown"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["NStart"], self.param_names["NEnd"]
            ),  # start should be smaller since we are picking up
            # check there is a block to stand on
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(self.PLACEHOLDER, x_end),
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPosition2Down"]
                    ),
                    AtZLocationPredicate.to_precondition(self.PLACEHOLDER, z_end),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_end),
                        # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionDown"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            # check that the required item exists at the target location
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.param_names['Item']})\n",
                AtXLocationPredicate.to_precondition(self.param_names["Item"], x_end),
                AtYLocationPredicate.to_precondition(
                    self.param_names["Item"], self.param_names["YPositionDown"]
                ),
                AtZLocationPredicate.to_precondition(self.param_names["Item"], z_end),
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names["NStart"],
                item_type=self.item,
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_names["ZPositionStart"]
            end = self.param_names["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
            item_location_x = self.param_names["XPosition"]
            item_location_z = self.param_names["ZPositionEnd"]
        else:
            start = self.param_names["XPositionStart"]
            end = self.param_names["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate
            item_location_x = self.param_names["XPositionEnd"]
            item_location_z = self.param_names["ZPosition"]

        self.effects = pddl_and(
            pddl_not(
                predicate_to_use.to_precondition(self.param_names["Agent"], start)
            ),
            predicate_to_use.to_precondition(self.param_names["Agent"], end),
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_names["Agent"],
                    self.param_names["NStart"],
                    item_type=self.item,
                )
            ),
            pddl_not(
                AtXLocationPredicate.to_precondition(
                    self.param_names["Item"], item_location_x
                )
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Item"], self.param_names["YPositionDown"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(
                    self.param_names["Item"], item_location_z
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["NEnd"], item_type=self.item
            ),
            pddl_not(ItemPresentPredicate.to_precondition()),
        )


class Break(Action):
    def __init__(self, block: str, dir: str) -> None:
        super().__init__()
        self.block = block + "-block"
        self.item = block
        self.action_name = f"break-{block}-{dir}"
        self.dir = dir

        self.param_names = {
            "Agent": "?ag",
            "Block": "?b",
            "XPosition": "?x",
            "XPositionFront": "?x_front",
            "YPosition": "?y",
            "YPositionUp": "?y_up",
            "ZPosition": "?z",
            "ZPositionFront": "?z_front",
            "NStart": "?n_start",
            "NEnd": "?n_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "Block": self.block,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionFront": TypeName.POSITION_TYPE_NAME.value,
            "YPosition": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionFront": TypeName.POSITION_TYPE_NAME.value,
            "NStart": TypeName.COUNT_TYPE_NAME.value,
            "NEnd": TypeName.COUNT_TYPE_NAME.value,
        }

        self.move_east_west = self.dir == "east" or self.dir == "west"
        if self.move_east_west:
            self.x_front = "XPositionFront"
            self.z_front = "ZPosition"
        else:
            self.x_front = "XPosition"
            self.z_front = "ZPositionFront"

    def construct_parameters(self):
        self.parameters = ""
        for key in self.param_names.keys():
            if key == "XPositionFront" and (not self.move_east_west):
                continue
            elif key == "ZPositionFront" and (self.move_east_west):
                continue

            self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        if self.move_east_west:
            back = "XPosition"
            front = "XPositionFront"
        else:
            back = "ZPosition"
            front = "ZPositionFront"

        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["XPosition"]
            ),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["YPosition"]
            ),
            AtZLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["ZPosition"]
            ),
            AtXLocationPredicate.to_precondition(
                self.param_names["Block"], self.param_names[self.x_front]
            ),
            AtYLocationPredicate.to_precondition(
                self.param_names["Block"], self.param_names["YPosition"]
            ),
            AtZLocationPredicate.to_precondition(
                self.param_names["Block"], self.param_names[self.z_front]
            ),
            # this is a ternary
            AreSequentialPredicate.to_precondition(
                self.param_names[front], self.param_names[back]
            )
            if self.dir == "north" or self.dir == "west"
            else AreSequentialPredicate.to_precondition(
                self.param_names[back], self.param_names[front]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition"], self.param_names["YPositionUp"]
            ),
            f'({BlockPresentPredicate.var_name} {self.param_names["Block"]})',
            # make sure that there is not an item on top of the block - if it exists, we would have to account for it falling
            pddl_not(
                pddl_exists(
                    {TypeName.ITEM_TYPE_NAME.value: "?i"},
                    pddl_and(
                        f"({ItemPresentPredicate.var_name} ?i)\n",
                        AtXLocationPredicate.to_precondition(
                            "?i", self.param_names[self.x_front]
                        ),
                        AtYLocationPredicate.to_precondition(
                            "?i", self.param_names["YPositionUp"]
                        ),
                        AtZLocationPredicate.to_precondition(
                            "?i", self.param_names[self.z_front]
                        ),
                    ),
                ),
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["NStart"], self.param_names["NEnd"]
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names["NStart"],
                item_type=self.item,
            ),
        )

    def construct_effects(self):
        self.effects = pddl_and(
            # set NOT block present, block location, previous inventory count
            # set TRUE current inventory count
            pddl_not(f'({BlockPresentPredicate.var_name} {self.param_names["Block"]})'),
            pddl_not(
                AtXLocationPredicate.to_precondition(
                    self.param_names["Block"], self.param_names[self.x_front]
                )
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Block"], self.param_names["YPosition"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(
                    self.param_names["Block"], self.param_names[self.z_front]
                )
            ),
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_names["Agent"],
                    self.param_names["NStart"],
                    item_type=self.item,
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["NEnd"], item_type=self.item
            ),
        )


class Place(Action):
    def __init__(self, block: str, dir: str) -> None:
        super().__init__()
        # separate the names of blocks and items in pddl
        self.block = block + "-block"
        self.item = block
        self.action_name = f"place-{block}-{dir}"
        self.dir = dir

        self.param_names = {
            "Agent": "?ag",
            "Block": "?b",
            "XPosition": "?x",
            "XPositionFront": "?x_front",
            "YPosition": "?y",
            "YPositionDown": "?y_down",
            "ZPosition": "?z",
            "ZPositionFront": "?z_front",
            "NStart": "?n_start",
            "NEnd": "?n_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "Block": self.block,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionFront": TypeName.POSITION_TYPE_NAME.value,
            "YPosition": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionFront": TypeName.POSITION_TYPE_NAME.value,
            "NStart": TypeName.COUNT_TYPE_NAME.value,
            "NEnd": TypeName.COUNT_TYPE_NAME.value,
        }

        self.move_east_west = self.dir == "east" or self.dir == "west"
        if self.move_east_west:
            self.x_front = "XPositionFront"
            self.z_front = "ZPosition"
        else:
            self.x_front = "XPosition"
            self.z_front = "ZPositionFront"

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        self.parameters = ""
        for key in self.param_names.keys():
            if key == "XPositionFront" and (not self.move_east_west):
                continue
            elif key == "ZPositionFront" and (self.move_east_west):
                continue

            self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        if self.move_east_west:
            back = "XPosition"
            front = "XPositionFront"
        else:
            back = "ZPosition"
            front = "ZPositionFront"

        block_var = "?bl"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            # set the agent position
            AtXLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["XPosition"]
            ),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["YPosition"]
            ),
            AtZLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["ZPosition"]
            ),
            # check that the block we want to place does not exist
            pddl_not(f'({BlockPresentPredicate.var_name} {self.param_names["Block"]})'),
            # There must be a block one down and one in front of us, for support for the block we are placing
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names[self.x_front]
                    ),
                    # There must be a block underneath
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPositionDown"]
                    ),
                    # The block must be in front of us
                    AtZLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names[self.z_front]
                    ),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            # There mustn't be a block at the same location we are placing the new block
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(
                            block_var, self.param_names[self.x_front]
                        ),
                        AtYLocationPredicate.to_precondition(
                            block_var, self.param_names["YPosition"]
                        ),
                        AtZLocationPredicate.to_precondition(
                            block_var,
                            self.param_names[self.z_front],
                        ),
                    ),
                )
            ),
            # There must not be an item at the location we are placing the new block
            pddl_not(
                pddl_exists(
                    {TypeName.ITEM_TYPE_NAME.value: "?i"},
                    pddl_and(
                        f"({ItemPresentPredicate.var_name} ?i)\n",
                        AtXLocationPredicate.to_precondition(
                            "?i", self.param_names[self.x_front]
                        ),
                        AtYLocationPredicate.to_precondition(
                            "?i", self.param_names["YPosition"]
                        ),
                        AtZLocationPredicate.to_precondition(
                            "?i", self.param_names[self.z_front]
                        ),
                    ),
                )
            ),
            # Housekeeping
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPosition"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names[front], self.param_names[back]
            )
            if self.dir == "north" or self.dir == "west"
            else AreSequentialPredicate.to_precondition(
                self.param_names[back], self.param_names[front]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["NEnd"], self.param_names["NStart"]
            ),  # start should be bigger since we are placing
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names["NStart"],
                item_type=self.item,
            ),
        )

    def construct_effects(self):
        self.effects = pddl_and(
            f'({BlockPresentPredicate.var_name} {self.param_names["Block"]})',
            AtXLocationPredicate.to_precondition(
                self.param_names["Block"], self.param_names[self.x_front]
            ),
            AtYLocationPredicate.to_precondition(
                self.param_names["Block"], self.param_names["YPosition"]
            ),
            AtZLocationPredicate.to_precondition(
                self.param_names["Block"], self.param_names[self.z_front]
            ),
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_names["Agent"],
                    self.param_names["NStart"],
                    item_type=self.item,
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["NEnd"], item_type=self.item
            ),
        )


class JumpUp(Action):
    # jumps up one block forward
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"jumpup-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_names = {
            "Agent": "?ag",
            "XPosition": "?x",
            "ZPosition": "?z",
            "XPositionStart": "?x_start",
            "XPositionEnd": "?x_end",
            "YPositionUp": "?y_up",
            "YPositionUpUp": "?y_up_up",  # for jumping up
            "YPositionDown": "?y_down",
            "ZPositionStart": "?z_start",
            "ZPositionEnd": "?z_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "XPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUpUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionEnd": TypeName.POSITION_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        # depending on the direction of travel, we need to check that the end location is not occupied by a block/item
        # we will set the x_start, x_end, z_start, and z_end variables to hold the relevant arg names so we can just look them up later
        move_east_west = self.dir == "east" or self.dir == "west"
        direction_should_increase = self.dir == "south" or self.dir == "east"
        if move_east_west:
            x_start = self.param_names["XPositionStart"]
            x_end = self.param_names["XPositionEnd"]
        else:
            x_start = self.param_names["XPosition"]
            x_end = self.param_names["XPosition"]

        if not move_east_west:
            z_start = self.param_names["ZPositionStart"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            z_start = self.param_names["ZPosition"]
            z_end = self.param_names["ZPosition"]

        # todo: confirm that these orders are correct
        if direction_should_increase:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_start if move_east_west else z_start,
                x_end if move_east_west else z_end,
            )
        else:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_end if move_east_west else z_end,
                x_start if move_east_west else z_start,
            )

        block_var = "?b"
        item_var = "?i"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_names["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_names["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionUp"], self.param_names["YPositionUpUp"]
            ),
            # check that we can jump in the current column (required before we can move forward)
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_start),
                        # only check upup, since up is occupied by the agent
                        AtYLocationPredicate.to_precondition(
                            block_var, self.param_names["YPositionUpUp"]
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_start),
                    ),
                )
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_end),
                        # check there is no block blocking the agent's "double height"
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUpUp"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(self.PLACEHOLDER, x_end),
                    # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPositionDown"]
                    ),
                    AtZLocationPredicate.to_precondition(self.PLACEHOLDER, z_end),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.ITEM_TYPE_NAME.value: item_var},
                    pddl_and(
                        f"({ItemPresentPredicate.var_name} {item_var})\n",
                        AtXLocationPredicate.to_precondition(item_var, x_end),
                        # here we only check that there is no item at the level of the agent (bottom) since items cannot float
                        # they would require a block to be placed beneath it, which is handled by the previous precondition
                        AtYLocationPredicate.to_precondition(
                            item_var, self.param_names["YPositionUp"]
                        ),
                        AtZLocationPredicate.to_precondition(item_var, z_end),
                    ),
                )
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_names["ZPositionStart"]
            end = self.param_names["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
        else:
            start = self.param_names["XPositionStart"]
            end = self.param_names["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

        self.effects = pddl_and(
            pddl_not(
                predicate_to_use.to_precondition(self.param_names["Agent"], start)
            ),
            predicate_to_use.to_precondition(self.param_names["Agent"], end),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Agent"], self.param_names["YPositionDown"]
                )
            ),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["YPositionUp"]
            ),
        )


class JumpUpAndPickup(Action):
    # jumps up one block forward and pickup the item at that location
    def __init__(self, dir: str, item: str) -> None:
        super().__init__()
        self.dir = dir
        self.item = item
        self.action_name = f"jumpup_and_pickup-{item}-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_names = {
            "Agent": "?ag",
            "Item": "?i",
            "XPosition": "?x",
            "ZPosition": "?z",
            "XPositionStart": "?x_start",
            "XPositionEnd": "?x_end",
            "YPositionUp": "?y_up",
            "YPositionUpUp": "?y_up_up",  # for jumping up
            "YPositionDown": "?y_down",
            "ZPositionStart": "?z_start",
            "ZPositionEnd": "?z_end",
            "NStart": "?n_start",
            "NEnd": "?n_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "Item": self.item,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "XPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUpUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "NStart": TypeName.COUNT_TYPE_NAME.value,
            "NEnd": TypeName.COUNT_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        # depending on the direction of travel, we need to check that the end location is not occupied by a block/item
        # we will set the x_start, x_end, z_start, and z_end variables to hold the relevant arg names so we can just look them up later
        move_east_west = self.dir == "east" or self.dir == "west"
        direction_should_increase = self.dir == "south" or self.dir == "east"
        if move_east_west:
            x_start = self.param_names["XPositionStart"]
            x_end = self.param_names["XPositionEnd"]
        else:
            x_start = self.param_names["XPosition"]
            x_end = self.param_names["XPosition"]

        if not move_east_west:
            z_start = self.param_names["ZPositionStart"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            z_start = self.param_names["ZPosition"]
            z_end = self.param_names["ZPosition"]

        # todo: confirm that these orders are correct
        if direction_should_increase:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_start if move_east_west else z_start,
                x_end if move_east_west else z_end,
            )
        else:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_end if move_east_west else z_end,
                x_start if move_east_west else z_start,
            )

        block_var = "?b"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_names["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_names["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionUp"], self.param_names["YPositionUpUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["NStart"], self.param_names["NEnd"]
            ),
            # check that there is no block blocking the agent's "double height" in the target column
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_end),
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUpUp"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            # check that there is no block blocking the agent's "double height" in the current column
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_start),
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUpUp"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_start),
                    ),
                )
            ),
            # check that there is a block to land on (target column)
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(self.PLACEHOLDER, x_end),
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPositionDown"]
                    ),
                    AtZLocationPredicate.to_precondition(self.PLACEHOLDER, z_end),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            # check that the required item can be picked up
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.param_names['Item']})\n",
                AtXLocationPredicate.to_precondition(self.param_names["Item"], x_end),
                AtYLocationPredicate.to_precondition(
                    self.param_names["Item"], self.param_names["YPositionUp"]
                ),
                AtZLocationPredicate.to_precondition(self.param_names["Item"], z_end),
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names["NStart"],
                item_type=self.item,
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_names["ZPositionStart"]
            end = self.param_names["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate

            x_end = self.param_names["XPosition"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            start = self.param_names["XPositionStart"]
            end = self.param_names["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

            x_end = self.param_names["XPositionEnd"]
            z_end = self.param_names["ZPosition"]

        self.effects = pddl_and(
            # agent is not at the start location
            pddl_not(
                predicate_to_use.to_precondition(self.param_names["Agent"], start)
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Agent"], self.param_names["YPositionDown"]
                )
            ),
            # agent is at the end location
            predicate_to_use.to_precondition(self.param_names["Agent"], end),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["YPositionUp"]
            ),
            # agent picked up item - update inventory count
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_names["Agent"],
                    self.param_names["NStart"],
                    item_type=self.item,
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["NEnd"], item_type=self.item
            ),
            # remove the item from the world
            pddl_not(f"({ItemPresentPredicate.var_name} {self.param_names['Item']})"),
            pddl_not(
                AtXLocationPredicate.to_precondition(self.param_names["Item"], x_end)
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Item"], self.param_names["YPositionUp"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(self.param_names["Item"], z_end)
            ),
        )


class JumpDown(Action):
    # jumps down one block forward
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"jumpdown-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_names = {
            "Agent": "?ag",
            "XPosition": "?x",
            "ZPosition": "?z",
            "XPositionStart": "?x_start",
            "XPositionEnd": "?x_end",
            "YPositionUp": "?y_up",
            "YPositionDown": "?y_down",  # where legs are
            "YPosition2Down": "?y_2_down",  # for jumping down
            "YPosition3Down": "?y_3_down",  # for making sure there is landing space
            "ZPositionStart": "?z_start",
            "ZPositionEnd": "?z_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "XPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "YPosition2Down": TypeName.POSITION_TYPE_NAME.value,
            "YPosition3Down": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionEnd": TypeName.POSITION_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        # depending on the direction of travel, we need to check that the end location is not occupied by a block/item
        # we will set the x_start, x_end, z_start, and z_end variables to hold the relevant arg names so we can just look them up later
        move_east_west = self.dir == "east" or self.dir == "west"
        direction_should_increase = self.dir == "south" or self.dir == "east"
        if move_east_west:
            x_start = self.param_names["XPositionStart"]
            x_end = self.param_names["XPositionEnd"]
        else:
            x_start = self.param_names["XPosition"]
            x_end = self.param_names["XPosition"]

        if not move_east_west:
            z_start = self.param_names["ZPositionStart"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            z_start = self.param_names["ZPosition"]
            z_end = self.param_names["ZPosition"]

        # todo: confirm that these orders are correct
        if direction_should_increase:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_start if move_east_west else z_start,
                x_end if move_east_west else z_end,
            )
        else:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_end if move_east_west else z_end,
                x_start if move_east_west else z_start,
            )

        block_var = "?b"
        item_var = "?i"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_names["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_names["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition3Down"], self.param_names["YPosition2Down"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition2Down"], self.param_names["YPositionDown"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPositionUp"]
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_end),
                        # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionDown"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPosition2Down"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(self.PLACEHOLDER, x_end),
                    # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPosition3Down"]
                    ),
                    AtZLocationPredicate.to_precondition(self.PLACEHOLDER, z_end),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            pddl_not(
                pddl_exists(
                    {TypeName.ITEM_TYPE_NAME.value: item_var},
                    pddl_and(
                        f"({ItemPresentPredicate.var_name} {item_var})\n",
                        AtXLocationPredicate.to_precondition(item_var, x_end),
                        # here we only check that there is no item at the level of the agent (bottom) since items cannot float
                        # they would require a block to be placed beneath it, which is handled by the previous precondition
                        pddl_or(
                            AtYLocationPredicate.to_precondition(
                                item_var, self.param_names["YPosition2Down"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(item_var, z_end),
                    ),
                )
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_names["ZPositionStart"]
            end = self.param_names["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
        else:
            start = self.param_names["XPositionStart"]
            end = self.param_names["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

        self.effects = pddl_and(
            pddl_not(
                predicate_to_use.to_precondition(self.param_names["Agent"], start)
            ),
            predicate_to_use.to_precondition(self.param_names["Agent"], end),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Agent"], self.param_names["YPositionDown"]
                )
            ),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["YPosition2Down"]
            ),
        )


class JumpDownAndPickup(Action):
    # jumps down one block forward and pickup the item at that location
    def __init__(self, dir: str, item: str) -> None:
        super().__init__()
        self.dir = dir
        self.item = item
        self.action_name = f"jumpdown_and_pickup-{item}-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_names = {
            "Agent": "?ag",
            "Item": "?i",
            "XPosition": "?x",
            "ZPosition": "?z",
            "XPositionStart": "?x_start",
            "XPositionEnd": "?x_end",
            "YPositionUp": "?y_up",
            "YPositionDown": "?y_down",  # where legs are
            "YPosition2Down": "?y_2_down",  # for jumping down
            "YPosition3Down": "?y_3_down",  # for making sure there is landing space
            "ZPositionStart": "?z_start",
            "ZPositionEnd": "?z_end",
            "NStart": "?n_start",
            "NEnd": "?n_end",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
            "Item": self.item,
            "XPosition": TypeName.POSITION_TYPE_NAME.value,
            "ZPosition": TypeName.POSITION_TYPE_NAME.value,
            "XPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "XPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "YPositionUp": TypeName.POSITION_TYPE_NAME.value,
            "YPositionDown": TypeName.POSITION_TYPE_NAME.value,
            "YPosition2Down": TypeName.POSITION_TYPE_NAME.value,
            "YPosition3Down": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionStart": TypeName.POSITION_TYPE_NAME.value,
            "ZPositionEnd": TypeName.POSITION_TYPE_NAME.value,
            "NStart": TypeName.COUNT_TYPE_NAME.value,
            "NEnd": TypeName.COUNT_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters
            self.param_names["Block1"] = "?b1"
            self.param_types["Block1"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_names[key]} - {self.param_types[key]} "
                    )
                else:
                    continue

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        # depending on the direction of travel, we need to check that the end location is not occupied by a block/item
        # we will set the x_start, x_end, z_start, and z_end variables to hold the relevant arg names so we can just look them up later
        move_east_west = self.dir == "east" or self.dir == "west"
        direction_should_increase = self.dir == "south" or self.dir == "east"
        if move_east_west:
            x_start = self.param_names["XPositionStart"]
            x_end = self.param_names["XPositionEnd"]
        else:
            x_start = self.param_names["XPosition"]
            x_end = self.param_names["XPosition"]

        if not move_east_west:
            z_start = self.param_names["ZPositionStart"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            z_start = self.param_names["ZPosition"]
            z_end = self.param_names["ZPosition"]

        # todo: confirm that these orders are correct
        if direction_should_increase:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_start if move_east_west else z_start,
                x_end if move_east_west else z_end,
            )
        else:
            sequential_predicate = AreSequentialPredicate.to_precondition(
                x_end if move_east_west else z_end,
                x_start if move_east_west else z_start,
            )

        block_var = "?b"
        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_names["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_names["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition3Down"], self.param_names["YPosition2Down"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPosition2Down"], self.param_names["YPositionDown"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["YPositionDown"], self.param_names["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_names["NStart"], self.param_names["NEnd"]
            ),
            # check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: block_var},
                    pddl_and(
                        f"({BlockPresentPredicate.var_name} {block_var})\n",
                        AtXLocationPredicate.to_precondition(block_var, x_end),
                        pddl_or(
                            # eyeline
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionUp"]
                            ),
                            # legs
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPositionDown"]
                            ),
                            # target location
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_names["YPosition2Down"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            # check that there is a block to land on
            self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(self.PLACEHOLDER, x_end),
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER, self.param_names["YPosition3Down"]
                    ),
                    AtZLocationPredicate.to_precondition(self.PLACEHOLDER, z_end),
                ),
                True,
                self.param_names["Block1"] if self.lifted_representation else block_var,
            ),
            # check that the required item exists at the target location
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.param_names['Item']})\n",
                AtXLocationPredicate.to_precondition(self.param_names["Item"], x_end),
                AtYLocationPredicate.to_precondition(
                    self.param_names["Item"], self.param_names["YPosition2Down"]
                ),
                AtZLocationPredicate.to_precondition(self.param_names["Item"], z_end),
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"],
                self.param_names["NStart"],
                item_type=self.item,
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_names["ZPositionStart"]
            end = self.param_names["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate

            x_end = self.param_names["XPosition"]
            z_end = self.param_names["ZPositionEnd"]
        else:
            start = self.param_names["XPositionStart"]
            end = self.param_names["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

            x_end = self.param_names["XPositionEnd"]
            z_end = self.param_names["ZPosition"]

        self.effects = pddl_and(
            # agent is not at the start location
            pddl_not(
                predicate_to_use.to_precondition(self.param_names["Agent"], start)
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Agent"], self.param_names["YPositionDown"]
                )
            ),
            # agent is present at the end location
            predicate_to_use.to_precondition(self.param_names["Agent"], end),
            AtYLocationPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["YPosition2Down"]
            ),
            # agent picked up item - update inventory count
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_names["Agent"],
                    self.param_names["NStart"],
                    item_type=self.item,
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_names["Agent"], self.param_names["NEnd"], item_type=self.item
            ),
            # remove the item from the world
            pddl_not(f"({ItemPresentPredicate.var_name} {self.param_names['Item']})"),
            pddl_not(
                AtXLocationPredicate.to_precondition(self.param_names["Item"], x_end)
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_names["Item"], self.param_names["YPositionUp"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(self.param_names["Item"], z_end)
            ),
        )


class CheckGoal(Action):
    # checks the goal achieved predicate of the agent
    def __init__(self, goal, max_inentory_stack: int) -> None:
        super().__init__()
        self.action_name = "checkgoal"  # this is the only action name that doesn't follow the convention
        self.goal = goal
        self.max_inventory_stack = max_inentory_stack

        self.param_names = {
            "Agent": "?ag",
        }

        self.param_types = {
            "Agent": TypeName.AGENT_TYPE_NAME.value,
        }

    def set_lifted_representation(self, lifted_representation: bool) -> None:
        super().set_lifted_representation(lifted_representation)

        if self.lifted_representation:
            # if we are generating a lifted representation, we need to remove existential statements
            # so we need to use some extra parameters

            blocks = self.goal["blocks"] if "blocks" in self.goal else []

            for i in range(1, len(blocks) + 1):
                self.param_names[f"Block{i}"] = f"?b{i}"
                self.param_types[f"Block{i}"] = TypeName.BLOCK_TYPE_NAME.value

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_names.keys():
            self.parameters += f"{self.param_names[key]} - {self.param_types[key]} "

        self.parameters = self.parameters.strip()

    def construct_preconditions(self):
        agents = self.goal["agent"] if "agent" in self.goal else []
        blocks = self.goal["blocks"] if "blocks" in self.goal else []
        inventory = self.goal["inventory"] if "inventory" in self.goal else []

        agent_pddl = ""
        block_pddl = ""
        item_pddl = ""

        for agent in agents:
            # add the agent's position
            agent_pddl += pddl_and(
                AtXLocationPredicate.to_precondition(
                    self.param_names["Agent"],
                    PositionType.construct_problem_object(
                        int(np.floor(float(agent["position"]["x"])))
                    ),
                ),
                AtYLocationPredicate.to_precondition(
                    self.param_names["Agent"],
                    PositionType.construct_problem_object(
                        int(np.floor(float(agent["position"]["y"])))
                    ),
                ),
                AtZLocationPredicate.to_precondition(
                    self.param_names["Agent"],
                    PositionType.construct_problem_object(
                        int(np.floor(float(agent["position"]["z"])))
                    ),
                ),
            )

        block_var = "?b"
        for i, block in enumerate(blocks):
            block_pddl += self.exists_builder(
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {self.PLACEHOLDER})\n",
                    AtXLocationPredicate.to_precondition(
                        self.PLACEHOLDER,
                        PositionType.construct_problem_object(
                            int(np.floor(float(block["position"]["x"])))
                        ),
                    ),
                    AtYLocationPredicate.to_precondition(
                        self.PLACEHOLDER,
                        PositionType.construct_problem_object(
                            int(np.floor(float(block["position"]["y"])))
                        ),
                    ),
                    AtZLocationPredicate.to_precondition(
                        self.PLACEHOLDER,
                        PositionType.construct_problem_object(
                            int(np.floor(float(block["position"]["z"])))
                        ),
                    ),
                ),
                True,
                self.param_names[f"Block{i + 1}"]
                if self.lifted_representation
                else block_var,
                block["type"] + "-block",
            )
            block_pddl += "\n\t"

        for item in inventory:
            # each item in the inventory needs to have at least the specified quantity
            args = []
            for i in range(int(item["quantity"]), self.max_inventory_stack):
                args.append(
                    AgentHasNItemsPredicate.to_precondition(
                        self.param_names["Agent"],
                        CountType.construct_problem_object(i),
                        item_type=item["type"],
                    )
                )
            item_pddl += pddl_or(*args)

        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.param_names['Agent']})\n",
            agent_pddl,
            block_pddl,
            item_pddl,
        )

    def construct_effects(self):
        self.effects = pddl_and(
            f"({GoalAchievedPredicate.var_name} {self.param_names['Agent']})"
        )
