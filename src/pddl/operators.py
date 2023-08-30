from typing import List, Tuple, Dict

# TODO: catch invalid arguments


def pddl_and(*args):
    return f"(and {' '.join(args)})"


def pddl_or(*args):
    return f"(or {' '.join(args)})"


def pddl_exists(arguments: Dict, *args):
    out = f"(exists ("
    for arg in arguments:
        out += f"{arguments[arg]} - {arg}"
    out += f") {' '.join(args)})"
    return out


def pddl_not(*args):
    return f"(not {' '.join(args)})"


def pddl_equal(*args):
    return f"(= {' '.join(args)})"


def pddl_add(*args):
    return f"(+ {' '.join(args)})"


# used for effects
def pddl_increase(*args):
    return f"(increase {' '.join(args)})"


def pddl_decrease(*args):
    return f"(decrease {' '.join(args)})"


def pddl_ge(*args):
    return f"(>= {' '.join(args)})"


def pddl_assign(*args):
    return f"(assign {' '.join(args)})"


def pddl_less(*args):
    return f"(< {' '.join(args)})"


# TODO: potentially change to this implementation
# def pddl_precondition(*args, precondition):
#     return f"({precondition} {' '.join(f'({args})')})"
