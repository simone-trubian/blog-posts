from functools import reduce
from string import ascii_letters
from random import randrange, choice
from typing import List, Iterator

FILE_PATH = 'list.txt'

# -------------------------------------------------------------------------- #
#           File Generation
# -------------------------------------------------------------------------- #
def genLine() -> str:
    return ''.join((choice(ascii_letters) for _ in
                    range(randrange(3, 15)))) + '\n'

def genFile(count: int) -> None:
    with open('list.txt', 'w') as out_file:
        for line in range(count):
            out_file.write(genLine())


# -------------------------------------------------------------------------- #
#           Vanilla in-memory list.
# -------------------------------------------------------------------------- #
def get_file(file_path: str) -> List[str]:
    with open(file_path, 'r') as in_file:
        str_list = []
        for line in in_file:
            str_list.append(line)

        return str_list

def mapping_fun(in_str: str) -> int:
    return len([char for char in in_str if char.isupper()])

#def for_red(in_list: Iterator[int]) -> int: FIXME: make this fun generic.
def for_red(in_list):
    sum = 0
    for count in in_list: sum += count
    return sum

# -------------------------------------------------------------------------- #
#           List comprehensions.
# -------------------------------------------------------------------------- #
def comp_fil(in_list: List[str]) -> List[str]:
    return [row for row in in_list if len(row) > 3 and len(row) < 15 ]

def comp_map(in_list: List[str]) -> List[int]:
    return [mapping_fun(row) for row in in_list]

# -------------------------------------------------------------------------- #
#           Generators
# -------------------------------------------------------------------------- #
def gen_fil(in_list: List[str]) -> Iterator[str]:
    return (row for row in in_list if len(row) > 3 and len(row) < 15 )

def gen_map(in_list: Iterator[str]) -> Iterator[int]:
    return (mapping_fun(row) for row in in_list)

# -------------------------------------------------------------------------- #
#           Built-in functions.
# -------------------------------------------------------------------------- #
def buil_fil(in_list: List[str]) -> Iterator[str]:
    return filter(lambda row: len(row) > 3 and len(row) < 15, in_list)

def buil_map(in_list: Iterator[str]) -> Iterator[int]:
    #import ipdb; ipdb.set_trace()
    return map(lambda row: mapping_fun(row), in_list)

def buil_red(in_list: Iterator[int] )-> int:
    return reduce(lambda nex, prev: nex + prev, in_list)

# -------------------------------------------------------------------------- #
#           Callable functions.
# -------------------------------------------------------------------------- #
def comp_sum() -> int:
    return for_red(comp_map(comp_fil(get_file(FILE_PATH))))

def gen_sum() -> int:
    return for_red(gen_map(gen_fil(get_file(FILE_PATH))))

def buil_sum() -> int:
    return buil_red(buil_map(buil_fil(get_file(FILE_PATH))))

def sum_sum() -> int:
    return sum(buil_map(buil_fil(get_file(FILE_PATH))))
