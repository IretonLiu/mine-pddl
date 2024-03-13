"""
This script will compare the generated domain and problem pddl files in two locations and note any differences.
"""

import argparse
import os
from typing import List, Tuple

RED = "\033[31m"
GREEN = "\033[32m"
RESET = "\033[0m"


def construct_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--current-pddl-file-path",
        type=str,
        required=True,
        help="The root of the directory tree containing the new pddl files",
    )
    parser.add_argument(
        "--old-pddl-file-path",
        type=str,
        required=True,
        help="The root of the directory tree containing the old pddl files",
    )
    parser.add_argument(
        "--diff-folder", type=str, default="diff", help="The folder to store the diff"
    )

    return parser


def find_differences_in_files(
    file1: List[str], file2: List[str]
) -> List[Tuple[int, str, str]]:
    # returns a tuple of the line number and the lines

    line_num = 0
    output = []
    while line_num < len(file1) and line_num < len(file2):
        # get the two lines to compare
        file1_line = file1[line_num]
        file2_line = file2[line_num]

        # Removing whitespaces
        file1_line = file1_line.strip()
        file2_line = file2_line.strip()

        # Compare the lines from both file
        if file1_line != file2_line:
            # store the difference
            output.append((line_num + 1, file1_line, file2_line))

        line_num += 1

    # check if there's a bunch of extra lines in one of the files
    if len(file1) != len(file2):
        # get the extra lines
        first_longer = len(file1) > len(file2)
        for i in range(line_num, len(file1) if first_longer else len(file2)):
            if first_longer:
                output.append((i, file1[i], ""))
            else:
                output.append((i, "", file2[i]))

    return output


if __name__ == "__main__":
    parser = construct_argument_parser()
    args = parser.parse_args()

    # do a directory walk
    total_count = 0
    different_count = 0
    for dirpath, dirnames, filenames in os.walk(args.current_pddl_file_path):
        # check if there are pddl files here
        for filename in filenames:
            if ".pddl" in filename:
                # check if this file exists in the old directory
                old_filepath = os.path.join(
                    dirpath.replace(
                        args.current_pddl_file_path, args.old_pddl_file_path
                    ).replace("//", "/"),
                    filename,
                )
                if not os.path.exists(old_filepath):
                    print(
                        f"{RED}File {filename} does not exist in the old directory{RESET}"
                    )
                    continue

                # read the files
                with open(os.path.join(dirpath, filename)) as fp:
                    current_contents = fp.readlines()
                with open(old_filepath) as fp:
                    old_contents = fp.readlines()

                # find the differences
                differences: List[Tuple[int, str, str]] = find_differences_in_files(
                    current_contents, old_contents
                )

                # check if there are differences
                if len(differences) > 0:
                    print(f"{RED}File {filename} has differences{RESET}")

                    # make sure the diff folder exists
                    diff_folder = dirpath.replace(args.current_pddl_file_path, "")
                    diff_folder = os.path.join(
                        args.diff_folder,
                        diff_folder[1:] if diff_folder.startswith("/") else diff_folder,
                    )
                    os.makedirs(diff_folder, exist_ok=True)

                    # write the differences to a file
                    with open(os.path.join(diff_folder, filename), "w") as fp:
                        for line_num, file1_line, file2_line in differences:
                            fp.write(
                                f"Line {line_num}:\n\t- {file1_line}\n\t+ {file2_line}\n\n"
                            )
                    different_count += 1
                else:
                    print(f"{GREEN}File {filename} is the same{RESET}")

                total_count += 1

    print()
    print(
        f"Successfully checked {total_count} files, of which {different_count} were different"
    )
