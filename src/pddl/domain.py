import inspect
from collections import defaultdict
from typing import Any, Dict, List, Optional

import pddl.actions.actions_num as actions_num
import pddl.actions.actions_prop as actions_prop
import pddl.pddl_types.base_pddl_types as base_pddl_types
import pddl.pddl_types.named_pddl_types as named_pddl_types
import pddl.pddl_types.special_pddl_types as special_pddl_types
from pddl.functions import InventoryFunction
from pddl.predicates import AgentHasNItemsPredicate


class Domain:
    def __init__(self, name: str, max_inventory_stack: int, use_propositional: bool):
        self.name = name
        self.max_inventory_stack = max_inventory_stack
        self.types = None
        self.constants = []
        self.predicates = []
        self.functions = []
        self.actions = []
        self.requirements = []
        self.use_propositional = use_propositional

    def construct_types(
        self,
        item_types,
        block_types,
    ):
        types_dict = defaultdict(list)
        all_pddl_types = inspect.getmembers(base_pddl_types)

        if self.use_propositional:
            # the special types defines the propositional-specific types
            all_pddl_types.extend(inspect.getmembers(special_pddl_types))

        # print all the classes in the pddl.pddl_types.base_pddl_types module without classes from their own imports
        for name, cls in all_pddl_types:
            if inspect.isclass(cls) and (
                cls.__module__ == base_pddl_types.__name__
                or cls.__module__ == special_pddl_types.__name__
            ):
                # get the parent class of the obj if it has one
                parent = (
                    cls.__bases__[0] if cls.__bases__[0].__name__ != "object" else None
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
            ].append(key + "-block")

        # convert types_dict to string
        types_str = "(:types\n"

        # use queue to enforce the order of the types
        types_queue = [base_pddl_types.ObjectType.type_name]
        while types_queue != []:
            key = types_queue.pop(0)
            if key not in types_dict:
                continue
            types_str += "\t"
            for value in types_dict[key]:
                types_str += f"{value} "
                types_queue.append(value)

            types_str += f"- {key}\n"
        types_str += ")"
        return types_str

    # loop through all the classes, instantiate the object and return a list of strings
    def get_pddl_strings(
        self,
        modules,
        return_predicates: bool,
        items: Optional[Dict[str, List[named_pddl_types.NamedItemType]]] = None,
        blocks: Optional[Dict[str, List[named_pddl_types.NamedBlockType]]] = None,
    ):
        # return_predicates is true to return predicate strings and false to return function strings
        # items is only meaningful is we are processing functions <- not true for propositional pddl
        assert items is not None and blocks is not None

        output = []
        all_classes = []
        for module in modules:
            all_classes.extend(inspect.getmembers(module))
        module_names = [module.__name__ for module in modules]
        # loop through the classes
        for _, cls in all_classes:
            # don't do recursive imports
            if inspect.isclass(cls) and cls.__module__ in module_names:
                # create the object
                obj = cls(self.use_propositional)

                # get the predicate/function string
                # handle duplicate predicates/functions existing across different classes - this is done later
                if return_predicates:
                    for predicate in obj.predicates.values():
                        if isinstance(predicate, AgentHasNItemsPredicate):
                            if items is None:
                                raise ValueError(
                                    "Must pass items if there is an AgentHasNItemsPredicate"
                                )
                            for item in items:
                                output.append(predicate.to_domain(item))
                            for block in blocks:
                                output.append(predicate.to_domain(block))
                        else:
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

                            # todo: add the named blocks for the functions - confirm this works
                            for block in blocks:
                                output.append(function.to_domain(label=block))
                        else:
                            output.append(function.to_domain())

        return output

    def predicates_or_functions_helper(
        self,
        process_predicates: bool,
        items: Optional[Dict[str, List[named_pddl_types.NamedItemType]]] = None,
        blocks: Optional[Dict[str, List[named_pddl_types.NamedBlockType]]] = None,
    ):
        # process_predicates is true to process predicate strings and false to process function strings
        # items is only meaningful if we are processing functions (i.e. process_predicates is false) <- not true for propositional pddl

        # get the pddl representation for the types - is a list
        # only include special_pddl_types if we are processing propositional pddl
        types_list: List[Any] = [base_pddl_types]
        if self.use_propositional:
            types_list.append(special_pddl_types)
        pddl_strings = self.get_pddl_strings(
            types_list, process_predicates, items, blocks
        )
        pddl_strings.extend(
            self.get_pddl_strings([named_pddl_types], process_predicates, items, blocks)
        )

        # use a set to remove duplicate occurrences (e.g. if there is a common parent)
        pddl_string_set = set(pddl_strings)

        # build the string of predicates/functions
        output = "(:{}\n\t".format("predicates" if process_predicates else "functions")
        output += "\n\t".join(pddl_string_set)
        output += "\n)"

        return output

    def construct_predicates(
        self,
        items: Dict[str, List[named_pddl_types.NamedItemType]],
        blocks: Dict[str, List[named_pddl_types.NamedBlockType]],
    ):
        return self.predicates_or_functions_helper(True, items=items, blocks=blocks)

    def construct_functions(
        self,
        items: Dict[str, List[named_pddl_types.NamedItemType]],
        blocks: Dict[str, List[named_pddl_types.NamedBlockType]],
    ):
        return self.predicates_or_functions_helper(False, items=items, blocks=blocks)

    def construct_actions(
        self,
        items: Dict[str, List[named_pddl_types.NamedItemType]],
        blocks: Dict[str, List[named_pddl_types.NamedBlockType]],
        goal: Dict[str, List[Dict[str, Any]]],
    ):
        if self.use_propositional:
            module = actions_prop
        else:
            module = actions_num

        directions = ["north", "south", "east", "west"]

        for dir in directions:
            self.actions.append(module.Move(dir))
            self.actions.append(module.JumpUp(dir))
            self.actions.append(module.JumpDown(dir))
            for block in blocks:
                self.actions.append(module.Break(block, dir))
                self.actions.append(module.Place(block, dir))

        for item in items:
            for dir in directions:
                # todo: remove this when we get the muti-directional support for numerical pddl
                if not self.use_propositional and dir in directions[1:]:
                    break
                # todo: end remove

                self.actions.append(module.MoveAndPickup(dir, item))

        # handling check goal is special depending on what type of pddl we are using
        if self.use_propositional:
            self.actions.append(actions_prop.CheckGoal(goal, self.max_inventory_stack))
        else:
            self.actions.append(actions_num.CheckGoal(goal))

        action_str = ""
        for action in self.actions:
            action_str += "\n" + action.to_pddl() + "\n"
        return action_str

    def to_pddl(
        self,
        items: Dict[str, List[named_pddl_types.NamedItemType]],
        blocks: Dict[str, List[named_pddl_types.NamedBlockType]],
        goal: Dict[str, List[Dict[str, Any]]],
        file_path: str,
    ):
        pddl = f"(define (domain {self.name})\n"
        pddl += "(:requirements :typing {} :negative-preconditions :universal-preconditions :existential-preconditions)\n".format(
            "" if self.use_propositional else ":fluents"
        )
        pddl += self.construct_types(items, blocks) + "\n"
        pddl += self.construct_predicates(items, blocks) + "\n"
        if not self.use_propositional:
            pddl += self.construct_functions(items, blocks) + "\n"
        pddl += self.construct_actions(items, blocks, goal) + "\n"
        pddl += ")"

        with open(file_path, "w") as f:
            f.write(pddl)

        return pddl
