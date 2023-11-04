from pddl.pddl_types.base_pddl_types import ObjectType
from pddl.predicates import AreSequentialPredicate, NotEqualPredicate


# A pddl type used to count the number of objects of a certain type
# Used for propositionalization
class IntType(ObjectType):
    type_name = "int"

    def __init__(self, use_propositional: bool = True):
        # set use_propositional to True by default because this should only be used for propositional pddl
        super().__init__(use_propositional)

        if self.use_propositional:
            self.predicates[NotEqualPredicate] = NotEqualPredicate()
            self.predicates[AreSequentialPredicate] = AreSequentialPredicate()


class PositionType(IntType):
    type_name = "position"

    def __init__(self, use_propositional: bool = True):
        super().__init__(use_propositional)

    @staticmethod
    def construct_problem_object(num: int):
        return PositionType.type_name + str(num)


class CountType(IntType):
    type_name = "count"

    def __init__(self, use_propositional: bool = True):
        super().__init__(use_propositional)

    @staticmethod
    def construct_problem_object(num: int):
        return CountType.type_name + str(num)
