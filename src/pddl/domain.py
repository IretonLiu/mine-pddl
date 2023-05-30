from typing import Dict, Optional, Any
import inspect
import pddl.pddl_types.base_pddl_types as base_pddl_types
import pddl.pddl_types.named_pddl_types as named_pddl_types
from pddl.functions import InventoryFunction
from collections import defaultdict
from pddl.actions import *


class Domain:
    def __init__(self, name: str):
        self.name = name
        # self.obs = obs
        self.types = None
        self.constants = []
        self.predicates = []
        self.functions = []
        self.actions = []
        self.requirements = []

    def construct_types(self, item_types, block_types):
        types_dict = defaultdict(list)
        # print all the classes in the pddl.pddl_types.base_pddl_types module without classes from their own imports
        for name, cls in inspect.getmembers(base_pddl_types):
            if inspect.isclass(cls) and cls.__module__ == base_pddl_types.__name__:
                # get the parent class of the obj if it has one
                parent = (
                    cls.__bases__[0] if cls.__bases__[
                        0].__name__ != "object" else None
                )

                if parent:
                    types_dict[getattr(parent, "type_name", None)].append(
                        getattr(cls, "type_name", None)
                    )

        for key in item_types:
            types_dict["item"].append(key)

        for key in block_types:
            # TODO: check if block is destructible

            types_dict[
                getattr(base_pddl_types.DestructibleBlockType, "type_name")
            ].append(key+"-block")

        # convert types_dict to string
        types_str = "(:types\n"

        # use queue to enforce the order of the types
        types_queue = [base_pddl_types.ObjectType.type_name]
        while types_queue != []:
            key = types_queue.pop(0)
            if key not in types_dict:
                continue
            types_str += f"\t"
            for value in types_dict[key]:
                types_str += f"{value} "
                types_queue.append(value)

            types_str += f"- {key}\n"
        types_str += ")"
        return types_str

    # loop through all the classes, instantiate the object and return a list of strings
    def get_pddl_strings(
        self,
        module_name,
        return_predicates: bool,
        items: Optional[Dict[str, named_pddl_types.NamedItemType]] = None,
    ):
        # return_predicates is true to return predicate strings and false to return function strings
        # items is only meaningful is we are processing functions

        output = []
        # loop through the classes
        for name, cls in inspect.getmembers(module_name):
            # don't do recursive imports
            if inspect.isclass(cls) and cls.__module__ == module_name.__name__:
                # create the object
                obj = cls()

                # get the predicate/function string
                # handle duplicate predicates/functions existing across different classes - this is done later
                if return_predicates:
                    for predicate in obj.predicates.values():
                        output.append(predicate.to_domain())
                else:
                    for function in obj.functions.values():
                        # if the function is an Inventory, pass the items
                        """
                        todo: handling this special case may not be scalable
                        todo: we can change it so that the function searches a dict for the necessary data,
                        todo: and if it doesn't need data, then the function itself will decide it doesn't have to search the dict
                        """

                        if isinstance(function, InventoryFunction):
                            if items is None:
                                raise ValueError(
                                    "Must pass items if there is an InventoryFunction"
                                )
                            for item in items:
                                output.append(function.to_domain(label=item))
                        else:
                            output.append(function.to_domain())

        return output

    def predicates_or_functions_helper(
        self,
        process_predicates: bool,
        items: Optional[Dict[str, named_pddl_types.NamedItemType]] = None,
    ):
        # process_predicates is true to process predicate strings and false to process function strings
        # items is only meaningful if we are processing functions (i.e. process_predicates is false)

        # get the pddl representation for the types - is a list
        pddl_strings = self.get_pddl_strings(
            base_pddl_types, process_predicates, items)
        pddl_strings.extend(
            self.get_pddl_strings(named_pddl_types, process_predicates, items)
        )

        # use a set to remove duplicate occurrences (e.g. if there is a common parent)
        pddl_string_set = set(pddl_strings)

        # build the string of predicates/functions
        output = "(:{}\n\t".format(
            "predicates" if process_predicates else "functions")
        output += "\n\t".join(pddl_string_set)
        output += "\n)"

        return output

    def construct_predicates(self):
        return self.predicates_or_functions_helper(True)

    def construct_functions(self, items: Dict[str, named_pddl_types.NamedItemType]):
        return self.predicates_or_functions_helper(False, items=items)

    def construct_actions(self, items: Dict[str, named_pddl_types.NamedItemType], blocks: Dict[str, named_pddl_types.NamedBlockType], goal:Dict[str, List[Dict[str, Any]]]):
        self.actions: List[Action] = [Move("north"), Move("south"),
                        Move("east"), Move("west")]
        for item in items:
            self.actions.append(Pickup(item))
            self.actions.append(Drop(item))

        for block in blocks:
            self.actions.append(Break(block))
            self.actions.append(Place(block))

        self.actions.append(JumpUp())
        self.actions.append(CheckGoal(goal))
        action_str = ""
        for action in self.actions:
            action_str += "\n" + action.to_pddl() + "\n"
        return action_str

    def to_pddl(
        self,
        items: Dict[str, named_pddl_types.NamedItemType],
        blocks: Dict[str, named_pddl_types.NamedBlockType],
        goal: Dict[str, List[Dict[str, Any]]],
        file_path: str,
    ):
        pddl = f"(define (domain {self.name})\n"
        pddl += "(:requirements :typing :fluents :negative-preconditions :universal-preconditions :existential-preconditions)\n"
        pddl += self.construct_types(items, blocks) + "\n"
        pddl += self.construct_predicates() + "\n"
        pddl += self.construct_functions(items) + "\n"
        pddl += self.construct_actions(items, blocks, goal) + "\n"
        pddl += ")"

        with open(file_path, "w") as f:
            f.write(pddl)

        return pddl
