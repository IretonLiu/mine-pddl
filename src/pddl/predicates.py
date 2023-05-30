from typing import List
from pddl.pddl_types.types_names import TypeName
# TODO : add more ?


class Predicate:
    var_name = "predicate"
    def __init__(self):
        # self.parameter_name = object.name
        # self.object_type = object.type_name
        self.value = None
        self.arguments = {}

    def set_value(self, value: bool):
        # assign the value of this predicate
        self.value = value

    def to_domain(self):
        out = f"({self.var_name}"
        for arg in self.arguments:
            out += f" {arg} - {self.arguments[arg]}"
        out += ")"
        return out

    # TODO: add support for multiple parameters, have no idea how to do that
    def to_precondition(self):
        raise NotImplementedError(
            "to_precondition not implemented for this predicate")

    # todo: handle multiple parameters

    def to_problem(self, parent_object_name: str):
        # the parent_object_name is the specific name of the object to which this applies (i.e. with the number appended)
        pddl = f"({self.var_name} {parent_object_name})"
        if not self.value:
            pddl = f"(not {pddl})"
        return pddl


class ItemPresentPredicate(Predicate):
    var_name = "item-present"

    def __init__(self):
        super().__init__()
        # self.var_name = "item-present"
        self.arguments = {"?i": TypeName.ITEM_TYPE_NAME.value}

    def to_precondition(self):
        return f"({self.var_name} ?i)"


class BlockPresentPredicate(Predicate):
    var_name = "block-present"

    def __init__(self):
        super().__init__()
        self.arguments = {"?b": TypeName.BLOCK_TYPE_NAME.value}

    def to_precondition(self):
        return f"({self.var_name} ?b)"


class AgentAlivePredicate(Predicate):
    var_name = "agent-alive"

    def __init__(self):
        super().__init__()
        self.arguments = {"?ag": TypeName.AGENT_TYPE_NAME.value}

    def to_precondition(self):
        return f"({self.var_name} ?ag)"

class GoalAchievedPredicate(Predicate):
    var_name = "goal-achieved"

    def __init__(self):
        super().__init__()
        self.arguments = {"?ag": TypeName.AGENT_TYPE_NAME.value}
        self.value = False

    def to_precondition(self):
        return f"({self.var_name} ?g)"
