from typing import List

# TODO : add more ?


class Predicate:
    def __init__(self, name: str, parameters: List = []):
        self.name = name
        self.parameters = parameters
        self.value = None

    def set_value(self, value: bool):
        # assign the value of this predicate
        self.value = value

    def to_pddl(self):
        out = f"({self.name}"
        for parameter in self.parameters:
            out += f" ?{parameter}"
        out += ")"
        return out

    # todo: handle multiple parameters
    def to_pddl_with_values(self, parent_object_name: str):
        # the parent_object_name is the specific name of the object to which this applies (i.e. with the number appended)
        pddl = f"({self.name} {parent_object_name})"
        if not self.value:
            pddl = f"(not {pddl})"
        return pddl
