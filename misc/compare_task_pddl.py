"""
This script will compare the generated domain and problem pddl files in two locations and note any differences.
"""

import argparse
import os
from typing import List, Tuple

RED = "\033[31m"
YELLOW = "\033[33m"
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


def find_differences_in_files_part_one(
    file1: List[str], file2: List[str]
) -> List[Tuple[int, str, str]]:
    # returns a tuple of the line number and the lines

    """
    - ignore the first two lines (domain/problem name and requirements) since they are the same everywhere
    - then we get to types/objetcs, where each line needs to be split, sorted and compared
    """

    differences = []

    file1_words = []
    file2_words = []

    # line_num is the same for both files
    line_num = 0
    while line_num < len(file1):
        # get the two lines to compare
        file1_line = file1[line_num]
        file2_line = file2[line_num]

        # Removing whitespaces
        file1_line = file1_line.strip()
        file2_line = file2_line.strip()

        # split the lines
        file1_line = file1_line.split()
        file2_line = file2_line.split()

        # add to the collection
        file1_words.extend(file1_line)
        file2_words.extend(file2_line)

        line_num += 1

    # sort the lines
    file1_words.sort()
    file2_words.sort()

    # join the lines
    file1_words = " ".join(file1_words)
    file2_words = " ".join(file2_words)

    # Compare the lines from both file
    if file1_words != file2_words:
        # store the difference
        differences.append((line_num + 1, file1_words, file2_words))

    return differences


def find_differences_in_files_part_two(
    file1: List[str], file2: List[str]
) -> List[Tuple[int, str, str]]:
    # returns a tuple of the line number and the lines

    """
    Domain:
    - ignore the first two lines (domain/problem name and requirements) since they are the same everywhere
    - then we get to types/objetcs, where each line needs to be split, sorted and compared
    """

    differences = []

    # strip any whitespace
    file1_lines = [line.strip() for line in file1]
    file2_lines = [line.strip() for line in file2]

    # sort the two files
    file1_lines.sort()
    file2_lines.sort()

    line_num = 0
    while line_num < len(file1_lines) and line_num < len(file2_lines):
        # get the two lines to compare
        file1_line = file1_lines[line_num]
        file2_line = file2_lines[line_num]

        # Removing whitespaces
        file1_line = file1_line.strip()
        file2_line = file2_line.strip()

        # compare the lines
        if file1_line != file2_line:
            # store the difference
            differences.append((line_num + 1, file1_line, file2_line))

        line_num += 1

    # check if there's a bunch of extra lines in one of the files
    if len(file1_lines) != len(file2_lines):
        # get the extra lines
        first_longer = len(file1_lines) > len(file2_lines)
        for i in range(
            line_num, len(file1_lines) if first_longer else len(file2_lines)
        ):
            if first_longer:
                differences.append((i, file1_lines[i], ""))
            else:
                differences.append((i, "", file2_lines[i]))

    return differences


def find_differences_in_files(
    file1: List[str], file2: List[str], is_domain: bool
) -> List[Tuple[int, str, str]]:
    # returns a tuple of the line number and the lines

    """
    There is an issue of random order in the files.
    So what we will do is split the domain and problem files into two parts (where the second part will be sorted and compared line-by-line):

    - domain: first part is everything up until "predicates" and will require splitting each line and comparing the parts

    - problem: first part is everything up until "init" and will require splitting each line and comparing the parts
               the second part has the special case of ignoring positions offset by a single location (this is due to a slight change in the
                   positioning update which does not affect correctness, since it only shifts the world)

    This will work for the most part, but since the sorting will break the "container" of each section, there may be some differences that
    slip through the cracks.
    """

    if is_domain:
        section_part_separator = "action"
    else:
        section_part_separator = "init"

    # find the line where the first part ends in both files
    line_num = 0
    while line_num < len(file1):
        if f"(:{section_part_separator}" in file1[line_num]:
            break
        line_num += 1

    if f"(:{section_part_separator}" not in file2[line_num]:
        print(
            f"{RED}Error: The first part of the files are not the same length {RESET}"
        )
        return [(-1, "", "")]

    # compare the first part
    output = find_differences_in_files_part_one(file1[:line_num], file2[:line_num])

    if len(output) > 0:
        return output

    # compare the second part
    output = find_differences_in_files_part_two(file1[line_num:], file2[line_num:])

    return output


if __name__ == "__main__":
    parser = construct_argument_parser()
    args = parser.parse_args()

    # do a directory walk
    total_count = 0
    different_count = 0
    files_to_redo = []
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
                    if "Scaled" not in filename:
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
                    current_contents, old_contents, "_domain.pddl" in filename
                )

                # check if there are differences
                if len(differences) > 0:
                    print(
                        f"{YELLOW}File ({'prop' if 'proposition' in dirpath else 'num '}) {filename} has differences{RESET}"
                    )

                    file_to_redo = filename.replace("_domain.pddl", ".pddl").replace(
                        "_problem.pddl", ".pddl"
                    )
                    file_to_redo = (
                        "prop: " + file_to_redo
                        if "proposition" in dirpath
                        else file_to_redo
                    )
                    file_to_redo = (
                        "num:  " + file_to_redo
                        if "numerical" in dirpath
                        else file_to_redo
                    )
                    if file_to_redo not in files_to_redo:
                        files_to_redo.append(file_to_redo)

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
                # else:
                #     print(f"{GREEN}File {filename} is the same{RESET}")

                total_count += 1

    print()
    print(
        f"Successfully checked {total_count} files, of which {different_count} were different"
    )
    print("These are the files to redo:")
    files_to_redo.sort()
    print("\n".join(files_to_redo))
