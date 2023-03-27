from typing import List

# TODO : add more ?


class Predicate:
    def __init__(self, name: str, parameters: List = []):
        self.name = name
        self.parameters = parameters

    def to_pddl(self):
        out = f"({self.name}"
        for parameter in self.parameters:
            out += f" ?{parameter}"
        out += ")"
        return out
