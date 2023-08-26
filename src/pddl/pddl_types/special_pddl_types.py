
from pddl.predicates import *
from pddl.pddl_types.base_pddl_types import ObjectType
from pddl.pddl_types.types_names import TypeName

# A pddl type used to count the number of objects of a certain type
# Used for propositionalization
class IntType(ObjectType):
    type_name = "int"

    def __init__(self):
        super().__init__()
        self.predicates[NotEqualPredicate] = NotEqualPredicate()
        self.predicates[AreSequentialPredicate] = AreSequentialPredicate()


class PositionType(IntType):
    type_name = "position"
    def __init__(self):
        super().__init__()

class CountType(IntType):
    type_name = "count"
    def __init__(self):
        super().__init__()