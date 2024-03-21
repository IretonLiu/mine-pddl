from typing import Dict

# TODO: catch invalid arguments


def pddl_and(*args):
    args_filtered = []
    for a in args:
        if a is not None and a != "":
            args_filtered.append(a)
    return f"(and \n{' '.join(args_filtered)})"


def pddl_add_wrapper(first: str, second: int) -> str:
    # special-case wrapper for when the second string is just a number
    # if that number is 0, don't use pddl_add
    if second == 0:
        return first
    else:
        return pddl_add(first, str(second))


def pddl_or(*args):
    return f"(or {' '.join(args)})"


def pddl_exists(arguments: Dict, *args):
    out = "(exists ("
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
