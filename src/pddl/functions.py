from typing import List
from pddl.operators import *
# from pddl.pddl_types.base_pddl_types import *
from pddl.pddl_types.types_names import TypeName


class Function:
    var_name = None

    def __init__(self):
        self.arguments = {}
        self.value = None

    def set_value(self, value):
        self.value = value

    def to_domain(self, label=None):
        out = "("
        if not label is None:
            out += f"{self.var_name.format(label)} "
        else:
            out += f"{self.var_name} "

        for arg in self.arguments:
            out += f"{arg} - {self.arguments[arg]} "
        out += ")"
        return out

    def to_problem(self, parent_object_name: str, label=None):
        full_var_name = ""
        if not label is None:
            full_var_name = self.var_name.format(label)
        else:
            full_var_name = self.var_name

        if (len(self.arguments) == 1):
            return pddl_equal(
                f"({full_var_name} {parent_object_name})", str(self.value))
        else:
            # if there are multple arguments, we need to create a conjunction of equalities
            return pddl_and([pddl_equal(f"({full_var_name} {parent_object_name} {arg})", str(self.value[arg])) for arg in self.arguments])


class InventoryFunction(Function):
    var_name = "agent-num-{}"

    def __init__(self):
        super().__init__()
        # self.var_name = "agent-num-{}"
        # self.parameter_name = object.name
        # self.object_type = object.type_name
        self.arguments = {"?ag": TypeName.AGENT_TYPE_NAME.value}
        self.value = 0


class PositionFunction(Function):
    def __init__(self):
        self.arguments = {"?l": TypeName.LOCATABLE_TYPE_NAME.value}

    def to_precondition(self):
        return f"({self.var_name} ?l)"

        # return "(= ({} {}) {})\n\t(= ({} {}) {})\n\t(= ({} {}) {})".format(
        #     "x",
        #     parent_object_name,
        #     self.value[0],
        #     "y",
        #     parent_object_name,
        #     self.value[1],
        #     "z",
        #     parent_object_name,
        #     self.value[2],
        # )


class XPositionFunction(PositionFunction):
    var_name = "x"

    def __init__(self):
        super().__init__()


class YPositionFunction(PositionFunction):
    var_name = "y"

    def __init__(self):
        super().__init__()


class ZPositionFunction(PositionFunction):
    var_name = "z"

    def __init__(self):
        super().__init__()


class BlockHitsFunction(Function):
    var_name = "block-hits"

    def __init__(self):
        super().__init__()
        self.arguments = {"?b": TypeName.DESTRUCTIBLE_BLOCK_TYPE_NAME.value}
        self.value = 0
