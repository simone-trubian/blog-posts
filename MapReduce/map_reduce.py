from string import ascii_letters
from random import randrange, choice


def genLine() -> str:
    return ''.join((choice(ascii_letters) for _ in
                    range(randrange(3, 15)))) + '\n'


def genFile(count: int) -> None:
    with open('list.txt', 'w') as out_file:
        for line in range(count):
            out_file.write(genLine())
