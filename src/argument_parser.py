import argparse
from typing import Tuple, Dict


def coords_3d(arg: str) -> Tuple[int, int, int]:
    # check if have ( and ) and remove them
    if arg[0] == "(" and arg[-1] == ")":
        arg = arg[1:-1]

        # split the string into a tuple of ints
        try:
            x, y, z = arg.split(",")
            return (int(x), int(y), int(z))
        except:
            pass  # will raise error

    raise argparse.ArgumentTypeError(
        "Coords must be in the form (x,y,z), where x, y, z are ints"
    )


def agent_start_position(arg: str) -> Dict[str, float]:
    # check if have ( and ) and remove them
    if arg[0] == "(" and arg[-1] == ")":
        arg = arg[1:-1]

        # split the string into a dict of floats
        try:
            x, y, z, yaw, pitch = [float(a) for a in arg.split(",")]

            # check if x and z need to be incremented by 0.5 (if not already specified)
            if int(x) + 0.5 != x:
                x = int(x) + 0.5
            if int(z) + 0.5 != z:
                z = int(z) + 0.5

            return {
                "x": x,
                "y": y,
                "z": z,
                "yaw": yaw,
                "pitch": pitch,
            }
        except:
            pass  # will raise error

    raise argparse.ArgumentTypeError(
        "Agent start position must be in the form (x,y,z,yaw,pitch), where x, y, z, yaw, pitch are numbers"
    )


def get_args_parser():
    parser = argparse.ArgumentParser("Mine-PDDL", add_help=True)

    # General stuff
    parser.add_argument(
        "--world-config",
        type=str,
        default=None,
        help="path to the description of the world",
    )
    parser.add_argument(
        "--world-name", type=str, default="open-ended", help="Name of the world"
    )
    parser.add_argument(
        "--world-type", type=str, default="flat", help="Type of the world"
    )
    parser.add_argument(
        "--video-save-path",
        type=str,
        default="problems/our/images",
        help="Path to save the video (of the agent executing the provided plan)",
    )
    parser.add_argument(
        "--video-name", type=str, default="plan_video", help="Name of the video"
    )

    # args to generate/process PDDL
    parser.add_argument(
        "--domain-file",
        type=str,
        default=None,
        help="path to the PDDL domain file (note that this may be overwritten)",
    )
    parser.add_argument(
        "--problem-file",
        type=str,
        default=None,
        help="path to the PDDL problem file (note that this may be overwritten)",
    )
    parser.add_argument(
        "--plan-file",
        type=str,
        default=None,
        help="path to the PDDL plan file (note that this may be overwritten)",
    )

    # args to generate propositional or numerical PDDL
    parser.add_argument(
        "--pddl-type",
        type=str,
        choices=["propositional", "numerical"],
        help="specify if the PDDL files are propositional or numerical",
    )

    # args to define variables pertinent to the world
    parser.add_argument(
        "--max-inventory-stack",
        type=int,
        default=64,
        help="max stack size for inventory items",
    )
    parser.add_argument(
        "--observation-range",
        type=coords_3d,  # this a type conversion function
        default=(8, 4, 8),
        help="observation range of the agent in the form (x, y, z). Each component is the total range in that direction, where the agent is at the center",
    )
    parser.add_argument(
        "--agent-start-position",
        type=agent_start_position,
        default=(0.5, 4, 0.5, 0, 0),
        help="agent start position in the form (x, y, z, yaw, pitch), where x, y, z, yaw, pitch are numbers. Commonly, the yaw and pitch can be set to 0",
    )

    return parser
