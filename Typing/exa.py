from typing import Tuple, TypeVar

# This will Fail!
def incBoth(x: int, y:int) -> (int, int):
    return(x + 1, y + 1)

#def incBoth(x: int, y:int) -> Tuple[int, int]:
#    return(x + 1, y + 1)

Pair = Tuple[int, int]

Num = TypeVar('Num', int, float, complex)

def incPair(x: int, y:int) -> Pair:
    return(x + 1, y + 1)

#def add(x: int, y: int) -> int:
#    return x + y

def add(x: Num, y: Num) -> Num:
    return x + y

# Wrong
var = add('hello ', 'reader')
