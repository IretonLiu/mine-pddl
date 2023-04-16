from typing import List
from pddl.pddl_types.types_names import TypeName
from pddl.operators import *
from pddl.predicates import *
from pddl.functions import *


class Action:
    def __init__(self) -> None:
        self.name = None
        self.parameters = []
        self.preconditions = []
        self.effects = []


class Move(Action):

    def __init__(self, dir: str) -> None:
        super().__init__()
        self.dir = dir
        self.action_name = "move-" + dir
        self.parameters = {TypeName.AGENT_TYPE_NAME.value: "?ag"}

    def construct_preconditions(self):
        directions = {"north": "-1", "south": "1", "east": "1", "west": "-1"}
        if (self.dir == "east" or self.dir == "west"):
            x_equality = pddl_equal(f"({XPositionFunction.var_name} ?b)",
                                    pddl_add(
                                        f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                                        directions[self.dir]
                                    ))
        else:
            x_equality = pddl_equal(
                f"({XPositionFunction.var_name} ?b)", f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})")

        if (self.dir == "north" or self.dir == "south"):
            z_equality = pddl_equal(f"({ZPositionFunction.var_name} ?b)",
                                    pddl_add(
                                        f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                                        directions[self.dir]
                                    ))
        else:
            z_equality = pddl_equal(
                f"({ZPositionFunction.var_name} ?b)", f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})")

        self.preconditions = pddl_and(f"({AgentAlivePredicate.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})",
                                      pddl_not(pddl_exists({TypeName.BLOCK_TYPE_NAME.value: "?b"},
                                                           pddl_and(
                                          x_equality,
                                          pddl_equal(
                                              f"({YPositionFunction.var_name} ?b)", pddl_add(
                                                  f"({YPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})", "1")),
                                          z_equality,
                                      ))))

    def construct_effects(self):
        effect = ""
        if self.dir == "north":
            effect = pddl_decrease(
                f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})", "1")
        elif self.dir == "south":
            effect = pddl_increase(
                f"({ZPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})", "1")
        elif self.dir == "east":
            effect = pddl_increase(
                f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})", "1")
        elif self.dir == "west":
            effect = pddl_decrease(
                f"({XPositionFunction.var_name} {self.parameters[TypeName.AGENT_TYPE_NAME.value]})", "1")
        self.effects = pddl_and(effect)

    def to_pddl(self):
        self.construct_preconditions()
        self.construct_effects()
        out = f"(:action {self.action_name}\n"
        out += f"\t:parameters ({' '.join([f'{k} {v}' for k, v in self.parameters.items()])})\n"
        out += f"\t:precondition {self.preconditions}\n"
        out += f"\t:effect {self.effects}\n"
        out += ")\n"
        return out
