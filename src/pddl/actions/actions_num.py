from typing import Type, Union

from pddl.functions import (
    InventoryFunction,
    XPositionFunction,
    YPositionFunction,
    ZPositionFunction,
)
from pddl.operators import (
    pddl_add,
    pddl_add_wrapper,
    pddl_and,
    pddl_assign,
    pddl_decrease,
    pddl_equal,
    pddl_exists,
    pddl_ge,
    pddl_increase,
    pddl_not,
    pddl_or,
)
from pddl.pddl_types.types_names import TypeName
from pddl.predicates import (
    AgentAlivePredicate,
    BlockPresentPredicate,
    GoalAchievedPredicate,
    ItemPresentPredicate,
)

# todo: refactor the block_or_items_exists_at_location function to be more general and less repeated


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
        # self.item_to_pickup = item_to_pickup
        self.action_name = f"move-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag"}

    def construct_preconditions(self):
        directions = {"north": "-1", "south": "1", "east": "1", "west": "-1"}
        if self.dir == "east" or self.dir == "west":

            def x_equality(x):
                return pddl_equal(
                    f"({XPositionFunction.var_name} ?{x})",
                    pddl_add(
                        f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        directions[self.dir],
                    ),
                )

        else:

            def x_equality(x):
                return pddl_equal(
                    f"({XPositionFunction.var_name} ?{x})",
                    f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                )

        if self.dir == "north" or self.dir == "south":

            def z_equality(x):
                return pddl_equal(
                    f"({ZPositionFunction.var_name} ?{x})",
                    pddl_add(
                        f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        directions[self.dir],
                    ),
                )

        else:

            def z_equality(x):
                return pddl_equal(
                    f"({ZPositionFunction.var_name} ?{x})",
                    f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                )

        self.preconditions = pddl_and(
            f"({AgentAlivePredicate.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
            pddl_and(
                pddl_not(
                    pddl_exists(
                        {TypeName.BLOCK_TYPE_NAME.value: "?b"},
                        pddl_and(
                            x_equality("b"),
                            pddl_or(
                                pddl_equal(
                                    f"({YPositionFunction.var_name} ?b)",
                                    pddl_add(
                                        f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                                        "1",
                                    ),
                                ),
                                pddl_equal(
                                    f"({YPositionFunction.var_name} ?b)",
                                    f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                                ),
                            ),
                            z_equality("b"),
                        ),
                    )
                ),
                pddl_not(
                    pddl_exists(
                        {TypeName.ITEM_TYPE_NAME.value: "?i"},
                        pddl_and(
                            x_equality("i"),
                            pddl_equal(
                                f"({YPositionFunction.var_name} ?i)",
                                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            ),
                            z_equality("i"),
                        ),
                    )
                ),
            ),
        )

    def construct_effects(self):
        effect = ""
        if self.dir == "north":
            effect = pddl_decrease(
                f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        elif self.dir == "south":
            effect = pddl_increase(
                f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        elif self.dir == "east":
            effect = pddl_increase(
                f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        elif self.dir == "west":
            effect = pddl_decrease(
                f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        self.effects = pddl_and(effect)

    def to_pddl(self):
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({' '.join([f'{v} - {k}' for k, v in self.parameters.items()])})\n"
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
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag", item: "?i"}

    def construct_preconditions(self):
        directions = {"north": "-1", "south": "1", "east": "1", "west": "-1"}
        if self.dir == "east" or self.dir == "west":

            def x_equality(x):
                return pddl_equal(
                    f"({XPositionFunction.var_name} ?{x})",
                    pddl_add(
                        f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        directions[self.dir],
                    ),
                )

        else:

            def x_equality(x):
                return pddl_equal(
                    f"({XPositionFunction.var_name} ?{x})",
                    f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                )

        if self.dir == "north" or self.dir == "south":

            def z_equality(x):
                return pddl_equal(
                    f"({ZPositionFunction.var_name} ?{x})",
                    pddl_add(
                        f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        directions[self.dir],
                    ),
                )

        else:

            def z_equality(x):
                return pddl_equal(
                    f"({ZPositionFunction.var_name} ?{x})",
                    f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                )

        self.preconditions = pddl_and(
            # preconditions for items
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.parameters[self.item]})",
                x_equality("i"),
                pddl_equal(
                    f"({YPositionFunction.var_name} {self.parameters[self.item]})",
                    f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                ),
                z_equality("i"),
            ),
            # preconditions for movement
            pddl_not(
                pddl_exists(
                    {TypeName.BLOCK_TYPE_NAME.value: "?b"},
                    pddl_and(
                        x_equality("b"),
                        pddl_equal(
                            f"({YPositionFunction.var_name} ?b)",
                            pddl_add(
                                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                                "1",
                            ),
                        ),
                        z_equality("b"),
                    ),
                ),
            ),
        )

    def construct_effects(self):
        move_effect = ""
        if self.dir == "north":
            move_effect = pddl_decrease(
                f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        elif self.dir == "south":
            move_effect = pddl_increase(
                f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        elif self.dir == "east":
            move_effect = pddl_increase(
                f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        elif self.dir == "west":
            move_effect = pddl_decrease(
                f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                "1",
            )
        self.effects = pddl_and(
            pddl_increase(
                f"({InventoryFunction.var_name.format(self.item)} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                "1",
            ),
            pddl_not(f"({ItemPresentPredicate.var_name} {self.parameters[self.item]})"),
            move_effect,
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


class Break(Action):
    def __init__(self, block: str, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.block = block + "-block"
        self.item = block
        self.action_name = f"break-{block}-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag", self.block: "?b"}

        self.break_east_west = self.dir == "east" or self.dir == "west"
        self.break_pos_axis = self.dir == "south" or self.dir == "east"

    def construct_preconditions(self):
        # set up default x and z equalities
        x_equality = pddl_equal(
            f"({XPositionFunction.var_name} {self.parameters[self.block]})",
            f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
        )
        z_equality = pddl_equal(
            f"({ZPositionFunction.var_name} {self.parameters[self.block]})",
            f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
        )

        # are we operating in the east/west direction?
        if self.break_east_west:
            # operate in x dir
            x_equality = pddl_equal(
                f"({XPositionFunction.var_name} {self.parameters[self.block]})",
                pddl_add(
                    f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    "1" if self.break_pos_axis else "-1",
                ),
            )
        else:
            # operate in z dir
            z_equality = pddl_equal(
                f"({ZPositionFunction.var_name} {self.parameters[self.block]})",
                pddl_add(
                    f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    "1" if self.break_pos_axis else "-1",
                ),
            )

        self.preconditions = pddl_and(
            x_equality,
            pddl_equal(
                f"({YPositionFunction.var_name} {self.parameters[self.block]})",
                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
            ),
            z_equality,
            f"({BlockPresentPredicate.var_name} {self.parameters[self.block]})",
        )

    def construct_effects(self):
        self.effects = pddl_and(
            pddl_not(
                f"({BlockPresentPredicate.var_name} {self.parameters[self.block]})"
            ),
            pddl_increase(
                f"({InventoryFunction.var_name.format(self.item)} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                "1",
            ),
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


class Place(Action):
    def __init__(self, block: str, dir: str) -> None:
        super().__init__()
        # separate the names of blocks and items in pddl
        self.dir = dir
        self.block = block + "-block"
        self.item = block
        self.action_name = f"place-{block}-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag", self.block: "?b"}

        self.place_east_west = self.dir == "east" or self.dir == "west"
        self.place_pos_axis = self.dir == "south" or self.dir == "east"

    def construct_preconditions(self):
        def block_exists_at_location(
            block_name: str,
            x_modifier: int = 0,
            y_modifier: int = 0,
            z_modifier: int = 0,
        ) -> str:
            return pddl_exists(
                {TypeName.BLOCK_TYPE_NAME.value: block_name},
                pddl_and(
                    f"({BlockPresentPredicate.var_name} {block_name})",
                    pddl_equal(
                        f"({XPositionFunction.var_name} {block_name})",
                        pddl_add_wrapper(
                            f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            x_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({YPositionFunction.var_name} {block_name})",
                        pddl_add_wrapper(
                            f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            y_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({ZPositionFunction.var_name} {block_name})",
                        pddl_add_wrapper(
                            f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            z_modifier,
                        ),
                    ),
                ),
            )

        x_modifier = (1 if self.place_pos_axis else -1) if self.place_east_west else 0
        z_modifier = (
            (1 if self.place_pos_axis else -1) if not self.place_east_west else 0
        )

        # todo: make sure that num inventory items > 0
        self.preconditions = pddl_and(
            block_exists_at_location(
                "?bl",
                x_modifier=x_modifier,
                y_modifier=-1,  # There must be a block underneath
                z_modifier=z_modifier,
            ),
            pddl_not(
                # There mustn't be a block at the same location
                block_exists_at_location(
                    "?bl",
                    x_modifier=x_modifier,
                    z_modifier=z_modifier,
                ),
            ),
            # there must be an item in the inventory to place
            pddl_ge(
                f"({InventoryFunction.var_name.format(self.item)} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                "1",
            ),
        )

    def construct_effects(self):
        def block_assign_at_location_component(
            location_function: Union[
                Type[XPositionFunction],
                Type[YPositionFunction],
                Type[ZPositionFunction],
            ],
            modifier: int = 0,
        ) -> str:
            return pddl_assign(
                f"({location_function.var_name} {self.parameters[self.block]})",
                pddl_add_wrapper(
                    f"({location_function.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    modifier,
                ),
            )

        x_modifier = (1 if self.place_pos_axis else -1) if self.place_east_west else 0
        z_modifier = (
            (1 if self.place_pos_axis else -1) if not self.place_east_west else 0
        )

        self.effects = pddl_and(
            f"({BlockPresentPredicate.var_name} {self.parameters[self.block]})",
            block_assign_at_location_component(XPositionFunction, x_modifier),
            block_assign_at_location_component(YPositionFunction, 0),
            block_assign_at_location_component(ZPositionFunction, z_modifier),
            pddl_decrease(
                f"({InventoryFunction.var_name.format(self.item)} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                "1",
            ),
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


class JumpUp(Action):
    # jumps up one block forward
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"jumpup-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag"}

        self.jump_east_west = self.dir == "east" or self.dir == "west"
        self.jump_pos_axis = self.dir == "south" or self.dir == "east"

    def construct_preconditions(self):
        def block_or_item_exists_at_location(
            block_exists: bool,  # True for block; False for item
            object_name: str,
            x_modifier: int = 0,
            y_modifier: int = 0,
            z_modifier: int = 0,
        ) -> str:
            object_exists_typename = (
                TypeName.BLOCK_TYPE_NAME.value
                if block_exists
                else TypeName.ITEM_TYPE_NAME.value
            )
            return pddl_exists(
                {object_exists_typename: object_name},
                pddl_and(
                    pddl_equal(
                        f"({XPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            x_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({YPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            y_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({ZPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            z_modifier,
                        ),
                    ),
                ),
            )

        x_modifier = (1 if self.jump_pos_axis else -1) if self.jump_east_west else 0
        z_modifier = (1 if self.jump_pos_axis else -1) if not self.jump_east_west else 0

        self.preconditions = pddl_and(
            # There must be a block underneath and infront
            block_or_item_exists_at_location(
                True, "?bl", x_modifier=x_modifier, z_modifier=z_modifier
            ),
            # there must not be a block where we are landing nor above us currently (nor the level above that, to account for the agent's "double height")
            pddl_not(
                pddl_or(
                    # where we are landing
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=1,
                        z_modifier=z_modifier,
                    ),
                    # above us currently
                    block_or_item_exists_at_location(True, "?bl", y_modifier=1),
                    # or the level above the previous two
                    # where we are landing
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=2,
                        z_modifier=z_modifier,
                    ),
                    # above us currently
                    block_or_item_exists_at_location(True, "?bl", y_modifier=2),
                )
            ),
            # there must not be an item where we are landing - we don't need to check above us because of gravity
            pddl_not(
                block_or_item_exists_at_location(
                    False,
                    "?i",
                    x_modifier=x_modifier,
                    y_modifier=1,
                    z_modifier=z_modifier,
                )
            ),
        )

    def construct_effects(self):
        position_function_to_change = (
            XPositionFunction if self.jump_east_west else ZPositionFunction
        )
        position_modifier = 1 if self.jump_pos_axis else -1

        self.effects = pddl_and(
            pddl_assign(
                f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    str(position_modifier),
                ),
            ),
            pddl_assign(
                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    "1",
                ),
            ),
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


class JumpUpAndPickup(Action):
    # jumps up one block forward
    def __init__(self, dir: str, item: str) -> None:
        super().__init__()
        self.dir = dir
        self.item_to_pickup = item
        self.action_name = f"jumpup_and_pickup-{item}-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag", item: "?i"}

        self.jump_east_west = self.dir == "east" or self.dir == "west"
        self.jump_pos_axis = self.dir == "south" or self.dir == "east"

    def construct_preconditions(self):
        def block_or_item_exists_at_location(
            block_exists: bool,  # True for block; False for item
            object_name: str,
            x_modifier: int = 0,
            y_modifier: int = 0,
            z_modifier: int = 0,
        ) -> str:
            object_exists_typename = (
                TypeName.BLOCK_TYPE_NAME.value
                if block_exists
                else TypeName.ITEM_TYPE_NAME.value
            )
            return pddl_exists(
                {object_exists_typename: object_name},
                pddl_and(
                    pddl_equal(
                        f"({XPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            x_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({YPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            y_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({ZPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            z_modifier,
                        ),
                    ),
                ),
            )

        x_modifier = (1 if self.jump_pos_axis else -1) if self.jump_east_west else 0
        z_modifier = (1 if self.jump_pos_axis else -1) if not self.jump_east_west else 0

        self.preconditions = pddl_and(
            # There must be a block underneath and infront
            block_or_item_exists_at_location(
                True, "?bl", x_modifier=x_modifier, z_modifier=z_modifier
            ),
            # there must not be a block where we are landing nor above us currently (nor the level above that, to account for the agent's "double height")
            pddl_not(
                pddl_or(
                    # where we are landing
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=1,
                        z_modifier=z_modifier,
                    ),
                    # above us currently
                    block_or_item_exists_at_location(True, "?bl", y_modifier=1),
                    # or the level above the previous two
                    # where we are landing
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=2,
                        z_modifier=z_modifier,
                    ),
                    # above us currently
                    block_or_item_exists_at_location(True, "?bl", y_modifier=2),
                )
            ),
            # there must be an item where we are landing (of the correct type)
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.parameters[self.item_to_pickup]})",
                pddl_equal(
                    f"({XPositionFunction.var_name} {self.parameters[self.item_to_pickup]})",
                    pddl_add_wrapper(
                        f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        x_modifier,
                    ),
                ),
                pddl_equal(
                    f"({YPositionFunction.var_name} {self.parameters[self.item_to_pickup]})",
                    pddl_add_wrapper(
                        f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        1,
                    ),
                ),
                pddl_equal(
                    f"({ZPositionFunction.var_name} {self.parameters[self.item_to_pickup]})",
                    pddl_add_wrapper(
                        f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        z_modifier,
                    ),
                ),
            ),
        )

    def construct_effects(self):
        position_function_to_change = (
            XPositionFunction if self.jump_east_west else ZPositionFunction
        )
        position_modifier = 1 if self.jump_pos_axis else -1

        self.effects = pddl_and(
            # handle the update of the agent's position
            pddl_assign(
                f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    str(position_modifier),
                ),
            ),
            pddl_assign(
                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    "1",
                ),
            ),
            # handle the removal of the item from the world and the updating of the inventory
            pddl_increase(
                f"({InventoryFunction.var_name.format(self.item_to_pickup)} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                "1",
            ),
            pddl_not(
                f"({ItemPresentPredicate.var_name} {self.parameters[self.item_to_pickup]})"
            ),
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


class JumpDown(Action):
    # jumps up one block forward
    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = f"jumpdown-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag"}

        self.jump_east_west = self.dir == "east" or self.dir == "west"
        self.jump_pos_axis = self.dir == "south" or self.dir == "east"

    def construct_preconditions(self):
        def block_or_item_exists_at_location(
            block_exists: bool,  # True for block; False for item
            object_name: str,
            x_modifier: int = 0,
            y_modifier: int = 0,
            z_modifier: int = 0,
        ) -> str:
            object_exists_typename = (
                TypeName.BLOCK_TYPE_NAME.value
                if block_exists
                else TypeName.ITEM_TYPE_NAME.value
            )
            return pddl_exists(
                {object_exists_typename: object_name},
                pddl_and(
                    pddl_equal(
                        f"({XPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            x_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({YPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            y_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({ZPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            z_modifier,
                        ),
                    ),
                ),
            )

        x_modifier = (1 if self.jump_pos_axis else -1) if self.jump_east_west else 0
        z_modifier = (1 if self.jump_pos_axis else -1) if not self.jump_east_west else 0

        self.preconditions = pddl_and(
            # There must be a block 2 underneath and infront
            block_or_item_exists_at_location(
                True, "?bl", x_modifier=x_modifier, y_modifier=-2, z_modifier=z_modifier
            ),
            # there must NOT be a block in front and 1 underneath, nor in line with the agent's legs or eyes
            pddl_not(
                pddl_or(
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=1,  # agent eyeline
                        z_modifier=z_modifier,
                    ),
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=0,  # agent's legs
                        z_modifier=z_modifier,
                    ),
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=-1,  # 1 below the agent
                        z_modifier=z_modifier,
                    ),
                )
            ),
            # there must not be an item anywhere on the "travel path"
            # gravity exists, so we only need to check the landing spot
            pddl_not(
                block_or_item_exists_at_location(
                    False,
                    "?i",
                    x_modifier=x_modifier,
                    y_modifier=-1,
                    z_modifier=z_modifier,
                )
            ),
        )

    def construct_effects(self):
        position_function_to_change = (
            XPositionFunction if self.jump_east_west else ZPositionFunction
        )
        position_modifier = 1 if self.jump_pos_axis else -1

        self.effects = pddl_and(
            pddl_assign(
                f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    str(position_modifier),
                ),
            ),
            pddl_assign(
                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    "-1",
                ),
            ),
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


class JumpDownAndPickup(Action):
    # jumps up one block forward
    def __init__(self, dir: str, item: str) -> None:
        super().__init__()
        self.dir = dir
        self.item_to_pickup = item
        self.action_name = f"jumpdown_and_pickup-{item}-{dir}"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag", item: "?i"}

        self.jump_east_west = self.dir == "east" or self.dir == "west"
        self.jump_pos_axis = self.dir == "south" or self.dir == "east"

    def construct_preconditions(self):
        def block_or_item_exists_at_location(
            block_exists: bool,  # True for block; False for item
            object_name: str,
            x_modifier: int = 0,
            y_modifier: int = 0,
            z_modifier: int = 0,
        ) -> str:
            object_exists_typename = (
                TypeName.BLOCK_TYPE_NAME.value
                if block_exists
                else TypeName.ITEM_TYPE_NAME.value
            )
            return pddl_exists(
                {object_exists_typename: object_name},
                pddl_and(
                    pddl_equal(
                        f"({XPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            x_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({YPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            y_modifier,
                        ),
                    ),
                    pddl_equal(
                        f"({ZPositionFunction.var_name} {object_name})",
                        pddl_add_wrapper(
                            f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                            z_modifier,
                        ),
                    ),
                ),
            )

        x_modifier = (1 if self.jump_pos_axis else -1) if self.jump_east_west else 0
        z_modifier = (1 if self.jump_pos_axis else -1) if not self.jump_east_west else 0

        self.preconditions = pddl_and(
            # There must be a block 2 underneath and infront
            block_or_item_exists_at_location(
                True, "?bl", x_modifier=x_modifier, y_modifier=-2, z_modifier=z_modifier
            ),
            # there must NOT be a block in front and 1 underneath, nor in line with the agent's legs or eyes
            pddl_not(
                pddl_or(
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=1,  # agent eyeline
                        z_modifier=z_modifier,
                    ),
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=0,  # agent's legs
                        z_modifier=z_modifier,
                    ),
                    block_or_item_exists_at_location(
                        True,
                        "?bl",
                        x_modifier=x_modifier,
                        y_modifier=-1,  # 1 below the agent
                        z_modifier=z_modifier,
                    ),
                )
            ),
            # there must be an item where we are landing (of the correct type)
            pddl_and(
                f"({ItemPresentPredicate.var_name} {self.parameters[self.item_to_pickup]})",
                pddl_equal(
                    f"({XPositionFunction.var_name} {self.parameters[self.item_to_pickup]})",
                    pddl_add_wrapper(
                        f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        x_modifier,
                    ),
                ),
                pddl_equal(
                    f"({YPositionFunction.var_name} {self.parameters[self.item_to_pickup]})",
                    pddl_add_wrapper(
                        f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        -1,
                    ),
                ),
                pddl_equal(
                    f"({ZPositionFunction.var_name} {self.parameters[self.item_to_pickup]})",
                    pddl_add_wrapper(
                        f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                        z_modifier,
                    ),
                ),
            ),
        )

    def construct_effects(self):
        position_function_to_change = (
            XPositionFunction if self.jump_east_west else ZPositionFunction
        )
        position_modifier = 1 if self.jump_pos_axis else -1

        self.effects = pddl_and(
            # handle the movement
            pddl_assign(
                f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({position_function_to_change.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    str(position_modifier),
                ),
            ),
            pddl_assign(
                f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                pddl_add(
                    f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                    "-1",
                ),
            ),
            # handle the removal of the item from the world and the updating of the inventory
            pddl_increase(
                f"({InventoryFunction.var_name.format(self.item_to_pickup)} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                "1",
            ),
            pddl_not(
                f"({ItemPresentPredicate.var_name} {self.parameters[self.item_to_pickup]})"
            ),
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


class CheckGoal(Action):
    # checks the goal achieved predicate of the agent
    def __init__(self, goal) -> None:
        self.action_name = "checkgoal"
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag"}
        self.goal = goal

    def construct_preconditions(self):
        blocks = self.goal["blocks"] if "blocks" in self.goal else []
        inventory = self.goal["inventory"] if "inventory" in self.goal else []

        block_pddl = ""
        item_pddl = ""

        for block in blocks:
            block_pddl += pddl_exists(
                {block["type"] + "-block": "?b"},
                pddl_and(
                    pddl_equal(
                        f"({XPositionFunction.var_name} ?b)", block["position"]["x"]
                    ),
                    pddl_equal(
                        f"({YPositionFunction.var_name} ?b)", block["position"]["y"]
                    ),
                    pddl_equal(
                        f"({ZPositionFunction.var_name} ?b)", block["position"]["z"]
                    ),
                ),
            )
            block_pddl += "\n\t"

        for item in inventory:
            # each item in the inventory needs to have at least the specified quantity
            item_pddl += pddl_ge(
                f"({InventoryFunction.var_name.format(item['type'])} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",  # type: ignore
                str(item["quantity"]),
            )

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
