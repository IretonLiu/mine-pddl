from typing import Dict

# TODO: catch invalid arguments


def add_pddl_prefix(*args, prefix: str = "not") -> str:
    # create the output string as normal
    output = " ".join(args)

    # remove whitespace
    output = output.strip()

    # check whether brackets already exist - if so, remove them
    remove_first = False
    remove_last = False
    if output.startswith("("):
        remove_first = True

    if output.endswith(")"):
        remove_last = True

    if remove_first != remove_last:
        print(output)
        raise ValueError("Mismatched brackets in NOT predicate")

    # remove brackets if necessary
    if remove_first:
        output = output[1:]
    if remove_last:
        output = output[:-1]

    # add the "not-" prefix
    return f"({prefix}-{output})\n"


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


def pddl_not(*args, lifted_representation: bool = False):
    # if we are generating pddl for a lifted planner, then we cannot have NOT preconditions
    # so we will have a standard predicate name that is just "not-" + the original predicate name
    if lifted_representation:
        return add_pddl_prefix(*args, prefix="not")
    else:
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
