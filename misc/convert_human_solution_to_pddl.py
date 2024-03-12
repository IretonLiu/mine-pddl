"""
Each task has been manually solved to prove a solution exists, and the trajectories have been stored
as a json array of action objects, where each action has the main action name (e.g. "move", "move_and_pickup")
and other relevant information, like the direction and the block\item to act on.

This script is responsible for converting the json action to their pddl form and saving the resultant file.
"""

import argparse
import os
import json
from typing import Dict


def construct_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--json-file-path",
        type=str,
        required=True,
        help="The root of the directory tree containing the human solutions",
    )
    parser.add_argument(
        "--pddl-file-path",
        type=str,
        required=True,
        help="The root of the directory tree in which to place the pddl",
    )

    return parser


def convert_json_action_to_pddl(json_action: Dict[str, str]) -> str:
    """
    Take the json form for a single action and convert it to the pddl form

    action name convention: {action_name_no_hyphen}-{args}-{direction}
    only the checkgoal action does not have a direction
    """

    pddl_action = json_action["action"]

    # check if we are acting on a block
    if "block" in json_action:
        pddl_action += f"-{json_action['block']}"

    # check if we are acting on an item (this is mutually exclusive to the "block" above)
    if "item" in json_action:
        pddl_action += f"-{json_action['item']}"

    if "direction" in json_action:
        # require the check since the check goal action does not have a direction
        pddl_action += f"-{json_action['direction']}"
    else:
        # just some validation that the direction has not been forgotten for another type of action
        assert json_action["action"] == "checkgoal"

    return pddl_action


if __name__ == "__main__":
    parser = construct_argument_parser()
    args = parser.parse_args()

    # do a directory walk
    count = 0
    for dirpath, dirnames, filenames in os.walk(args.json_file_path):
        # check if there are json files here
        for filename in filenames:
            if ".json" in filename:
                # read the json file
                with open(os.path.join(dirpath, filename)) as fp:
                    file_json = json.load(fp)

                # convert each action to pddl
                pddl_actions = []
                for action in file_json:
                    pddl_action = convert_json_action_to_pddl(action)
                    pddl_actions.append(f"({pddl_action})")

                # figure out what the target dir path is
                target_dirpath = dirpath.replace(
                    args.json_file_path, args.pddl_file_path
                )
                target_dirpath = target_dirpath.replace("//", "/")

                # make sure the dirpath exists
                os.makedirs(target_dirpath, exist_ok=True)

                # create the file
                target_filename = os.path.join(target_dirpath, filename)
                target_filename = target_filename.replace(".json", ".pddl")
                with open(target_filename, "w") as fp:
                    fp.write("\n".join(pddl_actions))
                    count += 1

    print(f"Successfully converted {count} files")
