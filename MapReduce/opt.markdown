# Optimization with large datasets.

Python and Haskell might seem like worlds apart. One is object-oriented, the other purely functional, one is dynamic the other static, one is interpreted the other compiled. Yet I find the two languages to have a similar feel: they both have a clan syntax, prefer a declarative approach to programming and provide high-level constructs.
In this post we're going to try both languages in a mapreduce-like job, the kind of work that is often necessary to do when analysing large amounts of data. However the task is a bit contrived it works as a good example and is very simple to understand. The job consists of reading a text file containing 12 million rows, filtering out the ones that are too short and too long, counting the number of Capital letters in it and then calculating the total number of letters.

An interesting aspect of mapreduce which is in some respects reminiscent of old school batch jobs, is that in many cases it only requires an initial IO phase to gather data and is concluded with a final IO phase to return the result. In between the two phases there can be an enormous amount of computation that is mostly pure. Furthermore it is the type of computation that often allows for parallelisation of the tasks. This is one of the reason why in my opinion functional languages can be a good fit for this type of computation.

A standard Python implementation could be something like
<pre><code xx="python"> from string import ascii_letters
from random import randrange, choice

def gen_line() -> str:
    return ''.join((choice(ascii_letters) for _ in
                    range(randrange(3, 15)))) + '\n'

def gen_file(count: int) -> None:
    with open(FILE_PATH, 'w') as out_file:
        for line in range(count):
            out_file.write(gen_line())


def get_file(file_path: str) -> List[str]:
    with open(file_path, 'r') as in_file:
        str_list = []
        for line in in_file:
            str_list.append(line)

        return str_list

def mapping_fun(in_str: str) -> int:
    return len([char for char in in_str if char.isupper()])

def for_red(in_list: Iterator[int]) -> int:
    sum = 0
    for count in in_list: sum += count
    return sum

def buil_fil(in_list: List[str]) -> Iterator[str]:
    return filter(lambda row: len(row) > 3 and len(row) < 15, in_list)

def buil_map(in_list: Iterator[str]) -> Iterator[int]:
    #import ipdb; ipdb.set_trace()
    return map(lambda row: mapping_fun(row), in_list)

def sum_sum() -> int:
    return sum(buil_map(buil_fil(get_file(FILE_PATH))))
</code></pre>

Here I'm using built-in functions that come with the standard Python distribution, the reader is wellcome to checkout the [blog repository](https://github.com/simone-trubian/blog-posts) for alternative implementations or better still experiment with his/her own.

The first two functions are used to generate the text file that will be used to run the performance tests. My testing environment is a laptop equipped with a 4 cores i7 and 16 Gb of RAM, please note that running times will differ according to the machine the tests are run on and the text file which is created randomly. After generating the text file we can use Ipython to time the function.
<pre><code xx="python">In [5]: %timeit mr.sum_sum()
1 loops, best of 3: 16.4 s per loop
</code></pre>
