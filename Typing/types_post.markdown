# Python type hinting

The newest version of Python, 3.5, has been recently released. Together with some smaller improvements, the team delighted us with two big updates, one of which is, perhaps, the beginning of a revolution. What I'm referring to is the addition of type hinting to the Python language, which may snowball in one of the biggest changes since the bumping up to version 3 in the last few years.

I'm being cautious because type hinting does not break backward compatibility, and is not even necessary, that is developers can avoid using this feature completely. It'll be interesting to see how well received and widespread hinting will be in the next few years, how willing to change the Python community will be.

The history of type hinting is actually longer that I originally thought. Hinting builds on the little-known type annotation feature as specified in [PEP3107](https://www.python.org/dev/peps/pep-3107/) that has been part of Python for already several years. Type annotations are information added to the declaration of functions and classes using standard Python syntax. Only CPython will completely ignore those annotations considering them comments. For example:
<bla>
>>> def add(x: int, y: int) -> int:
>>>   return x + y
</bla>
is entirely identical to
<bla>
>>> def add(x, y):
>>>   return x + y
</bla>

As a proof running the following
<bla>
>>> add(1, 2)
>>> 3
>>> add('hello ', 'reader')
>>> 'hello reader'
</bla>
doesn't break, despite the type annotation, as a further proof the behaviour is the same in all major versions of Python 3, 3.5 *included*.

At this point type annotations might seem like a useless feature, because there is nothing in the official release that actually uses them. In reality PEP3107 more like an official response to a community need. In other words some in the community wanted to add static type annotations to Python and the official release provided a structured *endorsed* way of doing it.

With time some external projects that provided type checking sprung up, some of which are rather good. In particular the [MyPy](http://mypy-lang.blogspot.co.uk/2015/04/mypy-02-released.html) inspired the Python people to come up with a structured type system that could deal with the dynamic nature of the language but also provide *optional* static typing.

The result of that effort is [PEP484](https://www.python.org/dev/peps/pep-0484/) an extensive specification of a gradual typing system that was co-authored by Guido van Rossum and Jukka Lehosalo, the author of the MyPy project. The purpose of this specification is to add a rigorous specification of static type checking that will help coordinating the efforts of the community. As the document states, type hinting is not static Python creeping in from the window (whether that is good or bad is for another post), but a valuable bolt-on feature at the disposal of the programmer.

In fact Python 3.5 only contains a new `typing` module containing classes and functions that comply with PEP484. That is to say there is still no official static type checker that ships with python, which explains why the examples shown above do not break even in Python 3.5.

If Python 3.5 ships with no type-checker, the MyPy project implements one compatible with the latest version of Python 3.4 that can be fetched simply using PIP. The implementation of MyPy checker is PEP484 compliant, but the implementation is not complete yet; that however will not prevent a curious mind from having some fun.

MyPy also comes with a `typing` module plus its very own type-checker that can be invoked by entering `mypy <python source file>` from the command line. The author considers the checker as a linter that the user can run on source code.

The type system specified by PEP484 is actually quite rich, for the sake of this post I'm just going to introduce some salient features it provides. For a start let's go back to the previous function, if we try running MyPy on the previous code we get
<bla>
Argument 1 to "add" has incompatible type "str"; expected "int"
Argument 2 to "add" has incompatible type "str"; expected "int"
</bla>

Here the type checker recognised the mistake of trying to add two strings.

The `typing` module comes with a series of convenience classes that help in creating types, for instance

<bla>
def incBoth(x: int, y:int) -> (int, int):
    return(x + 1, y + 1)
</bla>

will fail the check, throwing the exception

<bla>
assert False, 'Unsupported type %s' % type
AssertionError: Unsupported type Tuple[int?, int?]
</bla>
because the proper way to have tuples in PEP484 is to use the `Tuple` class, so the previous function becomes

<bla>
def incBoth(x: int, y:int) -> Tuple[int, int]:
    return(x + 1, y + 1)
</bla>

Another feature of Python gradual typing is the possibility to create type aliases, that is bind a type constructor to a name for convenience's sake, going back to the previous example we can re-write the function as

<bla>
from typing import Tuple

Pair = Tuple[int, int]
def incBoth(x: int, y:int) -> Pair:
    return(x + 1, y + 1)
</bla>

This far we've seen only functions that take and return one type only, but what what if we need more flexibility? For instance the `inc_both` function will break if we pass a float instead of an integer, and yet addition is a valid operator for decimal number as well. This pattern is often referred as generics, and rest assured Python is able to deal with that too. So if we want to re-write the function to accept any valid number in Python we can write:

<bla>
from typing import TypeVar

Num = TypeVar('Num', int, float, complex)

def add(x: Num, y: Num) -> Num:
    return x + y
</bla>

Where TypeVar is type *variable* class that generates a data type that can be either one of the types passed to its constructor. This is reminescent of the ML-style algebraic type system.

This is just a sample of the power and flexibility of the new Python type system, which also includes typing for classes, more powerful generics and more.
