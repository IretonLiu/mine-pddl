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

# for propositional logic
class AreSequentialPredicate(Predicate):
    var_name = "are-seq"

    def __init__(self):
        super().__init__()
        self.arguments = {"?x1": TypeName.INTEGER_TYPE_NAME.value, "?x2": TypeName.INTEGER_TYPE_NAME.value}

class NotEqualPredicate(Predicate):
    var_name = "not-equal"

    def __init__(self):
        super().__init__()
        self.arguments = {"?x1": TypeName.INTEGER_TYPE_NAME.value, "?x2": TypeName.INTEGER_TYPE_NAME.value}

class AgentHasNItemsPredicate(Predicate):
    var_name = "agent-has-n-{}"

    def __init__(self):
        super().__init__()
        self.arguments = {"?ag": TypeName.AGENT_TYPE_NAME.value, "?n": TypeName.COUNT_TYPE_NAME.value}
    
    def to_domain(self, item_type: str):
        full_var_name = self.var_name.format(item_type)
        out = f"({full_var_name}"
        for arg in self.arguments:
            out += f" {arg} - {self.arguments[arg]}"
        out += ")"
        return out


class AtLocationPredicate(Predicate):
    def __init__(self):
        super().__init__()
        self.arguments = {"?l": TypeName.LOCATABLE_TYPE_NAME.value}
    

class AtXLocationPredicate(AtLocationPredicate):
    var_name = "at-x"
    def __init__(self):
        super().__init__()
        self.arguments['?x'] = TypeName.POSITION_TYPE_NAME.value

    @staticmethod
    def to_precondition(first_arg: str, second_arg: str):
        return f"(at-x {first_arg} {second_arg})"



class AtYLocationPredicate(AtLocationPredicate):
    var_name = "at-y"
    def __init__(self):
        super().__init__()
        self.arguments['?y'] = TypeName.POSITION_TYPE_NAME.value

    @staticmethod
    def to_precondition(first_arg: str, second_arg: str):
        return f"(at-y {first_arg} {second_arg})"

class AtZLocationPredicate(AtLocationPredicate):
    var_name = "at-z"
    def __init__(self):
        super().__init__()
        self.arguments['?z'] = TypeName.POSITION_TYPE_NAME.value

    @staticmethod
    def to_precondition(first_arg: str, second_arg: str):
        return f"(at-z {first_arg} {second_arg})"

