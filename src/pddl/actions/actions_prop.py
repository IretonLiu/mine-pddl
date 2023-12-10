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

    def to_pddl(self) -> str:
        raise NotImplementedError


class Move(Action):
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"move-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_name = {
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

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_name.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_name[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
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
            x_start = self.param_name["XPositionStart"]
            x_end = self.param_name["XPositionEnd"]
        else:
            x_start = self.param_name["XPosition"]
            x_end = self.param_name["XPosition"]

        if not move_east_west:
            z_start = self.param_name["ZPositionStart"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            z_start = self.param_name["ZPosition"]
            z_end = self.param_name["ZPosition"]

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
            f"({AgentAlivePredicate.var_name} {self.param_name['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_name["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"],
                self.param_name[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_name["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionDown"], self.param_name["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPosition2Down"], self.param_name["YPositionDown"]
            ),
            # check there is a block to stand on
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(block_var, x_end),
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_name["YPosition2Down"]
                    ),
                    AtZLocationPredicate.to_precondition(block_var, z_end),
                ),
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionDown"]
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
                            item_var, self.param_name["YPositionDown"]
                        ),
                        AtZLocationPredicate.to_precondition(item_var, z_end),
                    ),
                )
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_name["ZPositionStart"]
            end = self.param_name["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
        else:
            start = self.param_name["XPositionStart"]
            end = self.param_name["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

        self.effects = pddl_and(
            pddl_not(predicate_to_use.to_precondition(self.param_name["Agent"], start)),
            predicate_to_use.to_precondition(self.param_name["Agent"], end),
        )

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


class MoveAndPickup(Action):
    def __init__(self, dir, item) -> None:
        super().__init__()
        self.dir = dir
        self.item = item
        self.action_name = f"move_and_pickup-{item}-{dir}"

        self.param_name = {
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

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_name.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_name[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
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
            x_start = self.param_name["XPositionStart"]
            x_end = self.param_name["XPositionEnd"]
        else:
            x_start = self.param_name["XPosition"]
            x_end = self.param_name["XPosition"]

        if not move_east_west:
            z_start = self.param_name["ZPositionStart"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            z_start = self.param_name["ZPosition"]
            z_end = self.param_name["ZPosition"]

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
            f"({AgentAlivePredicate.var_name} {self.param_name['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_name["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"],
                self.param_name[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_name["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionDown"], self.param_name["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPosition2Down"], self.param_name["YPositionDown"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["NStart"], self.param_name["NEnd"]
            ),  # start should be smaller since we are picking up
            # check there is a block to stand on
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(block_var, x_end),
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_name["YPosition2Down"]
                    ),
                    AtZLocationPredicate.to_precondition(block_var, z_end),
                ),
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionDown"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            # check that the required item exists at the target location
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.param_name['Item']})\n",
                AtXLocationPredicate.to_precondition(self.param_name["Item"], x_end),
                AtYLocationPredicate.to_precondition(
                    self.param_name["Item"], self.param_name["YPositionDown"]
                ),
                AtZLocationPredicate.to_precondition(self.param_name["Item"], z_end),
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["NStart"], item_type=self.item
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_name["ZPositionStart"]
            end = self.param_name["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
            item_location_x = self.param_name["XPosition"]
            item_location_z = self.param_name["ZPositionEnd"]
        else:
            start = self.param_name["XPositionStart"]
            end = self.param_name["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate
            item_location_x = self.param_name["XPositionEnd"]
            item_location_z = self.param_name["ZPosition"]

        self.effects = pddl_and(
            pddl_not(predicate_to_use.to_precondition(self.param_name["Agent"], start)),
            predicate_to_use.to_precondition(self.param_name["Agent"], end),
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_name["Agent"],
                    self.param_name["NStart"],
                    item_type=self.item,
                )
            ),
            pddl_not(
                AtXLocationPredicate.to_precondition(
                    self.param_name["Item"], item_location_x
                )
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Item"], self.param_name["YPositionDown"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(
                    self.param_name["Item"], item_location_z
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["NEnd"], item_type=self.item
            ),
            pddl_not(ItemPresentPredicate.to_precondition()),
        )

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


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

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


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
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(
                        block_var, self.param_names[self.x_front]
                    ),
                    # There must be a block underneath
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_names["YPositionDown"]
                    ),
                    # The block must be in front of us
                    AtZLocationPredicate.to_precondition(
                        block_var, self.param_names[self.z_front]
                    ),
                ),
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

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


class JumpUp(Action):
    # jumps up one block forward
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"jumpup-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_name = {
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

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_name.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_name[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
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
            x_start = self.param_name["XPositionStart"]
            x_end = self.param_name["XPositionEnd"]
        else:
            x_start = self.param_name["XPosition"]
            x_end = self.param_name["XPosition"]

        if not move_east_west:
            z_start = self.param_name["ZPositionStart"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            z_start = self.param_name["ZPosition"]
            z_end = self.param_name["ZPosition"]

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
            f"({AgentAlivePredicate.var_name} {self.param_name['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_name["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"],
                self.param_name[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_name["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionDown"], self.param_name["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionUp"], self.param_name["YPositionUpUp"]
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
                            block_var, self.param_name["YPositionUpUp"]
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionUpUp"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(block_var, x_end),
                    # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_name["YPositionDown"]
                    ),
                    AtZLocationPredicate.to_precondition(block_var, z_end),
                ),
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
                            item_var, self.param_name["YPositionUp"]
                        ),
                        AtZLocationPredicate.to_precondition(item_var, z_end),
                    ),
                )
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_name["ZPositionStart"]
            end = self.param_name["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
        else:
            start = self.param_name["XPositionStart"]
            end = self.param_name["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

        self.effects = pddl_and(
            pddl_not(predicate_to_use.to_precondition(self.param_name["Agent"], start)),
            predicate_to_use.to_precondition(self.param_name["Agent"], end),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Agent"], self.param_name["YPositionDown"]
                )
            ),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["YPositionUp"]
            ),
        )

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


class JumpUpAndPickup(Action):
    # jumps up one block forward and pickup the item at that location
    def __init__(self, dir: str, item: str) -> None:
        super().__init__()
        self.dir = dir
        self.item = item
        self.action_name = f"jumpup_and_pickup-{item}-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_name = {
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

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_name.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_name[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
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
            x_start = self.param_name["XPositionStart"]
            x_end = self.param_name["XPositionEnd"]
        else:
            x_start = self.param_name["XPosition"]
            x_end = self.param_name["XPosition"]

        if not move_east_west:
            z_start = self.param_name["ZPositionStart"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            z_start = self.param_name["ZPosition"]
            z_end = self.param_name["ZPosition"]

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
            f"({AgentAlivePredicate.var_name} {self.param_name['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_name["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"],
                self.param_name[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_name["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionDown"], self.param_name["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionUp"], self.param_name["YPositionUpUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["NStart"], self.param_name["NEnd"]
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionUpUp"]
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionUpUp"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_start),
                    ),
                )
            ),
            # check that there is a block to land on (target column)
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(block_var, x_end),
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_name["YPositionDown"]
                    ),
                    AtZLocationPredicate.to_precondition(block_var, z_end),
                ),
            ),
            # check that the required item can be picked up
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.param_name['Item']})\n",
                AtXLocationPredicate.to_precondition(self.param_name["Item"], x_end),
                AtYLocationPredicate.to_precondition(
                    self.param_name["Item"], self.param_name["YPositionUp"]
                ),
                AtZLocationPredicate.to_precondition(self.param_name["Item"], z_end),
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["NStart"], item_type=self.item
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_name["ZPositionStart"]
            end = self.param_name["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate

            x_end = self.param_name["XPosition"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            start = self.param_name["XPositionStart"]
            end = self.param_name["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

            x_end = self.param_name["XPositionEnd"]
            z_end = self.param_name["ZPosition"]

        self.effects = pddl_and(
            # agent is not at the start location
            pddl_not(predicate_to_use.to_precondition(self.param_name["Agent"], start)),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Agent"], self.param_name["YPositionDown"]
                )
            ),
            # agent is at the end location
            predicate_to_use.to_precondition(self.param_name["Agent"], end),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["YPositionUp"]
            ),
            # agent picked up item - update inventory count
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_name["Agent"],
                    self.param_name["NStart"],
                    item_type=self.item,
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["NEnd"], item_type=self.item
            ),
            # remove the item from the world
            pddl_not(f"({ItemPresentPredicate.var_name} {self.param_name['Item']})"),
            pddl_not(
                AtXLocationPredicate.to_precondition(self.param_name["Item"], x_end)
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Item"], self.param_name["YPositionUp"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(self.param_name["Item"], z_end)
            ),
        )

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


class JumpDown(Action):
    # jumps down one block forward
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"jumpdown-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_name = {
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

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_name.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_name[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
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
            x_start = self.param_name["XPositionStart"]
            x_end = self.param_name["XPositionEnd"]
        else:
            x_start = self.param_name["XPosition"]
            x_end = self.param_name["XPosition"]

        if not move_east_west:
            z_start = self.param_name["ZPositionStart"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            z_start = self.param_name["ZPosition"]
            z_end = self.param_name["ZPosition"]

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
            f"({AgentAlivePredicate.var_name} {self.param_name['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_name["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"],
                self.param_name[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_name["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_name["YPosition3Down"], self.param_name["YPosition2Down"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPosition2Down"], self.param_name["YPositionDown"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionDown"], self.param_name["YPositionUp"]
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionDown"]
                            ),
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPosition2Down"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(block_var, x_end),
                    # here we check that there is no block at the level of the agent (bottom) or the agent's eyeline (top)
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_name["YPosition3Down"]
                    ),
                    AtZLocationPredicate.to_precondition(block_var, z_end),
                ),
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
                                item_var, self.param_name["YPosition2Down"]
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
            start = self.param_name["ZPositionStart"]
            end = self.param_name["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate
        else:
            start = self.param_name["XPositionStart"]
            end = self.param_name["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

        self.effects = pddl_and(
            pddl_not(predicate_to_use.to_precondition(self.param_name["Agent"], start)),
            predicate_to_use.to_precondition(self.param_name["Agent"], end),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Agent"], self.param_name["YPositionDown"]
                )
            ),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["YPosition2Down"]
            ),
        )

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


class JumpDownAndPickup(Action):
    # jumps down one block forward and pickup the item at that location
    def __init__(self, dir: str, item: str) -> None:
        super().__init__()
        self.dir = dir
        self.item = item
        self.action_name = f"jumpdown_and_pickup-{item}-{dir}"

        # have separate dictionaries for parameter names and types, but such that a common key is used to index corresponding values in both
        # this is necessary because multiple parameters have different names but the same type
        self.param_name = {
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

    def construct_parameters(self):
        # need this generator since extra params have been added to the dicts in order to be more general
        move_east_west = self.dir == "east" or self.dir == "west"
        self.parameters = ""

        # loop through all the parameters and add them to the parameters dict if they are used
        for key in self.param_name.keys():
            # if we move east or west, we use x_start and x_end, but only z
            # if we move north or south, we use z_start and z_end, but only x

            # if we are not dealing with x or z positions, then process as normal
            if not ("XPosition" in key or "ZPosition" in key):
                self.parameters += f"{self.param_name[key]} - {self.param_types[key]} "
                continue

            if key == "XPositionStart" or key == "XPositionEnd" or key == "ZPosition":
                if move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
                    )
                else:
                    continue
            elif key == "XPosition" or key == "ZPositionStart" or key == "ZPositionEnd":
                if not move_east_west:
                    self.parameters += (
                        f"{self.param_name[key]} - {self.param_types[key]} "
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
            x_start = self.param_name["XPositionStart"]
            x_end = self.param_name["XPositionEnd"]
        else:
            x_start = self.param_name["XPosition"]
            x_end = self.param_name["XPosition"]

        if not move_east_west:
            z_start = self.param_name["ZPositionStart"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            z_start = self.param_name["ZPosition"]
            z_end = self.param_name["ZPosition"]

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
            f"({AgentAlivePredicate.var_name} {self.param_name['Agent']})\n",
            AtXLocationPredicate.to_precondition(self.param_name["Agent"], x_start),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"],
                self.param_name[
                    "YPositionDown"
                ],  # agent coord is the bottom of the agent
            ),
            AtZLocationPredicate.to_precondition(self.param_name["Agent"], z_start),
            sequential_predicate,
            AreSequentialPredicate.to_precondition(
                self.param_name["YPosition3Down"], self.param_name["YPosition2Down"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPosition2Down"], self.param_name["YPositionDown"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["YPositionDown"], self.param_name["YPositionUp"]
            ),
            AreSequentialPredicate.to_precondition(
                self.param_name["NStart"], self.param_name["NEnd"]
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
                                block_var, self.param_name["YPositionUp"]
                            ),
                            # legs
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPositionDown"]
                            ),
                            # target location
                            AtYLocationPredicate.to_precondition(
                                block_var, self.param_name["YPosition2Down"]
                            ),
                        ),
                        AtZLocationPredicate.to_precondition(block_var, z_end),
                    ),
                )
            ),
            # check that there is a block to land on
            pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(block_var, x_end),
                    AtYLocationPredicate.to_precondition(
                        block_var, self.param_name["YPosition3Down"]
                    ),
                    AtZLocationPredicate.to_precondition(block_var, z_end),
                ),
            ),
            # check that the required item exists at the target location
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.param_name['Item']})\n",
                AtXLocationPredicate.to_precondition(self.param_name["Item"], x_end),
                AtYLocationPredicate.to_precondition(
                    self.param_name["Item"], self.param_name["YPosition2Down"]
                ),
                AtZLocationPredicate.to_precondition(self.param_name["Item"], z_end),
            ),
            # add pressure for NStart to be meaningful
            AgentHasNItemsPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["NStart"], item_type=self.item
            ),
        )

    def construct_effects(self):
        # this is as simple as saying that agent is not at the start and is at the end
        if self.dir == "north" or self.dir == "south":
            start = self.param_name["ZPositionStart"]
            end = self.param_name["ZPositionEnd"]
            predicate_to_use = AtZLocationPredicate

            x_end = self.param_name["XPosition"]
            z_end = self.param_name["ZPositionEnd"]
        else:
            start = self.param_name["XPositionStart"]
            end = self.param_name["XPositionEnd"]
            predicate_to_use = AtXLocationPredicate

            x_end = self.param_name["XPositionEnd"]
            z_end = self.param_name["ZPosition"]

        self.effects = pddl_and(
            # agent is not at the start location
            pddl_not(predicate_to_use.to_precondition(self.param_name["Agent"], start)),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Agent"], self.param_name["YPositionDown"]
                )
            ),
            # agent is present at the end location
            predicate_to_use.to_precondition(self.param_name["Agent"], end),
            AtYLocationPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["YPosition2Down"]
            ),
            # agent picked up item - update inventory count
            pddl_not(
                AgentHasNItemsPredicate.to_precondition(
                    self.param_name["Agent"],
                    self.param_name["NStart"],
                    item_type=self.item,
                )
            ),
            AgentHasNItemsPredicate.to_precondition(
                self.param_name["Agent"], self.param_name["NEnd"], item_type=self.item
            ),
            # remove the item from the world
            pddl_not(f"({ItemPresentPredicate.var_name} {self.param_name['Item']})"),
            pddl_not(
                AtXLocationPredicate.to_precondition(self.param_name["Item"], x_end)
            ),
            pddl_not(
                AtYLocationPredicate.to_precondition(
                    self.param_name["Item"], self.param_name["YPositionUp"]
                )
            ),
            pddl_not(
                AtZLocationPredicate.to_precondition(self.param_name["Item"], z_end)
            ),
        )

    def to_pddl(self):
        self.construct_parameters()
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({self.parameters})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out


class CheckGoal(Action):
    # checks the goal achieved predicate of the agent
    def __init__(self, goal, max_inentory_stack: int) -> None:
        self.action_name = "checkgoal"  # this is the only action name that doesn't follow the convention
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag"}
        self.goal = goal
        self.max_inventory_stack = max_inentory_stack

    def construct_preconditions(self):
        blocks = self.goal["blocks"] if "blocks" in self.goal else []
        inventory = self.goal["inventory"] if "inventory" in self.goal else []

        block_pddl = ""
        item_pddl = ""

        block_var = "?b"
        for block in blocks:
            block_pddl += pddl_exists(
                {block["type"] + "-block": block_var},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_var})\n",
                    AtXLocationPredicate.to_precondition(
                        block_var,
                        PositionType.construct_problem_object(
                            int(np.floor(float(block["position"]["x"])))
                        ),
                    ),
                    AtYLocationPredicate.to_precondition(
                        block_var,
                        PositionType.construct_problem_object(
                            int(np.floor(float(block["position"]["y"])))
                        ),
                    ),
                    AtZLocationPredicate.to_precondition(
                        block_var,
                        PositionType.construct_problem_object(
                            int(np.floor(float(block["position"]["z"])))
                        ),
                    ),
                ),
            )
            block_pddl += "\n\t"

        for item in inventory:
            # each item in the inventory needs to have at least the specified quantity
            args = []
            for i in range(int(item["quantity"]), self.max_inventory_stack):
                args.append(
                    AgentHasNItemsPredicate.to_precondition(
                        self.parameters[TypeName.AGENT_TYPE_NAME.value],
                        CountType.construct_problem_object(i),
                        item_type=item["type"],
                    )
                )
            item_pddl += pddl_or(*args)

        self.preconditions = pddl_and(block_pddl, item_pddl)

    def construct_effects(self):
        self.effects = pddl_and(
            f"({GoalAchievedPredicate.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})"
        )

    def to_pddl(self):
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({' '.join([f'{v} - {k}' for k, v in self.parameters.items()])})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out
