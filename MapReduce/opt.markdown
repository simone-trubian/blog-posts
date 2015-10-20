# Optimization with large datasets.

Python and Haskell might seem like worlds apart. One is object-oriented, the other purely functional, one is dynamic the other static, one is interpreted the other compiled. Yet I find the two languages to have a similar feel: they both have a clan syntax, prefer a declarative approach to programming and provide high-level constructs.
In this post we're going to try both languages in a mapreduce-like job, the kind of work that is often necessary to do when analysing large amounts of data. However the task is a bit contrived it works as a good example and is very simple to understand. The job consists of reading a text file containing 12 million rows, filtering out the ones that are too short and too long, counting the number of Capital letters in it and then calculating the total number of letters.

An interesting aspect of mapreduce which is in some respects reminiscent of old school batch jobs, is that in many cases it only requires an initial IO phase to gather data and is concluded with a final IO phase to return the result. In between the two phases there can be an enormous amount of computation that is mostly pure. Furthermore it is the type of computation that often allows for parallelisation of the tasks. This is one of the reason why in my opinion functional languages can be a good fit for this type of computation.

A standard Python implementation could be something like
<pre><code class="python"> from string import ascii_letters
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
<pre><code class="python">In [5]: %timeit mr.sum_sum()
1 loops, best of 3: 16.4 s per loop
</code></pre>

This is the out of the box performance of Python, it runs in constant memory and uses one CPU core only. It will provide the reference against which to compare Haskell.

The same operation can be obtained in Haskell with.
<pre><code class="haskell">import Data.Char (isUpper)
import Data.List (foldl1')

filterStr :: [String] -> [String]
filterStr = filter (\s -> (length s > 3) && (length s < 15))

capCount :: String -> Int
capCount = foldl addUpper 0

addUpper :: Int -> Char -> Int
addUpper count char = if isUpper char then count + 1 else count

totCaps :: [String] -> Int
totCaps = sum . map capCount . filterStr


main :: IO ()
main = do
    file <- readFile "list.txt"
    print $ totCaps $ lines file
</code></pre>

Let's compile the souce code as is with only the `-rtsopts` flag to allow for basic profiling, then let's run the executable with `+RTS -sstderr`.

<pre><code>49503832
  28,213,590,928 bytes allocated in the heap
  12,120,060,960 bytes copied during GC
   2,229,231,024 bytes maximum residency (14 sample(s))
      47,675,496 bytes maximum slop
            4382 MB total memory in use (0 MB lost due to fragmentation)

                                    Tot time (elapsed)  Avg pause  Max pause
  Gen  0     54149 colls,     0 par   10.30s   10.31s     0.0002s    0.0021s
  Gen  1        14 colls,     0 par    4.64s    5.99s     0.4282s    2.8306s

  INIT    time    0.00s  (  0.00s elapsed)
  MUT     time   15.46s  ( 15.41s elapsed)
  GC      time   14.94s  ( 16.31s elapsed)
  EXIT    time    0.04s  (  0.24s elapsed)
  Total   time   30.44s  ( 31.96s elapsed)

  %GC     time      49.1%  (51.0% elapsed)

  Alloc rate    1,824,941,198 bytes per MUT second

  Productivity  50.9% of total user, 48.5% of total elapsed
</code></pre>
The first version of the compiled source actually runs half the speed of Python and consumes as much memory as it can get it hands on, oh dear! By a closer inspection of the printout it is clear that the amount of memory allocated to the heap and that has to be handled by the garbage collector is colossal. This is confirmed by the fact that almost half of the running time is taken by the GC itself. The root cause of the problem is most likely the last function, `sum` that is implemented as a right fold. Haskell being a lazy language means that the runtime is trying to allocate the entire 12 million record list before actually doing some computation. Plus it's doing it several times, one each passage. The first optimisation that we can easily do is to substitute the sum with a a better implementation:
<pre><code class="haskell">
totCaps = foldl1' (+) . map capCount . filterStr
</code></pre>
The foldl' function is an eager version of a fold left, which is the best suited for working with very large or indeed boundless structures. After re-compiling let's try running the program again.

trial 3 fold no opts.
<pre><code>49503832
  27,408,098,264 bytes allocated in the heap
   2,748,692,920 bytes copied during GC
         116,736 bytes maximum residency (1833 sample(s))
          41,984 bytes maximum slop
               2 MB total memory in use (0 MB lost due to fragmentation)

                                    Tot time (elapsed)  Avg pause  Max pause
  Gen  0     50824 colls,     0 par    2.81s    2.81s     0.0001s    0.0003s
  Gen  1      1833 colls,     0 par    0.19s    0.17s     0.0001s    0.0003s

  INIT    time    0.00s  (  0.00s elapsed)
  MUT     time   15.05s  ( 15.25s elapsed)
  GC      time    3.00s  (  2.99s elapsed)
  EXIT    time    0.00s  (  0.00s elapsed)
  Total   time   18.05s  ( 18.23s elapsed)

  %GC     time      16.6%  (16.4% elapsed)

  Alloc rate    1,821,378,140 bytes per MUT second

  Productivity  83.4% of total user, 82.5% of total elapsed
</code></pre>
trial 2 sum opt.

<pre><code>49503832
  24,152,302,232 bytes allocated in the heap
   1,153,660,608 bytes copied during GC
         102,112 bytes maximum residency (2 sample(s))
          24,720 bytes maximum slop
               1 MB total memory in use (0 MB lost due to fragmentation)

                                    Tot time (elapsed)  Avg pause  Max pause
  Gen  0     46408 colls,     0 par    1.22s    1.30s     0.0000s    0.0002s
  Gen  1         2 colls,     0 par    0.00s    0.00s     0.0001s    0.0002s

  INIT    time    0.00s  (  0.00s elapsed)
  MUT     time   11.12s  ( 11.19s elapsed)
  GC      time    1.22s  (  1.30s elapsed)
  EXIT    time    0.00s  (  0.00s elapsed)
  Total   time   12.35s  ( 12.49s elapsed)

  %GC     time       9.9%  (10.4% elapsed)

  Alloc rate    2,171,969,625 bytes per MUT second

  Productivity  90.1% of total user, 89.1% of total elapsed
</code></pre>



trial 4 foldl opts.
<pre><code>49503832
  24,152,302,216 bytes allocated in the heap
   1,153,660,608 bytes copied during GC
         102,112 bytes maximum residency (2 sample(s))
          24,720 bytes maximum slop
               1 MB total memory in use (0 MB lost due to fragmentation)

                                    Tot time (elapsed)  Avg pause  Max pause
  Gen  0     46408 colls,     0 par    1.14s    1.31s     0.0000s    0.0002s
  Gen  1         2 colls,     0 par    0.00s    0.00s     0.0001s    0.0002s

  INIT    time    0.00s  (  0.00s elapsed)
  MUT     time   11.25s  ( 11.14s elapsed)
  GC      time    1.14s  (  1.31s elapsed)
  EXIT    time    0.00s  (  0.00s elapsed)
  Total   time   12.39s  ( 12.46s elapsed)

  %GC     time       9.2%  (10.6% elapsed)

  Alloc rate    2,146,489,709 bytes per MUT second

  Productivity  90.8% of total user, 90.3% of total elapsed
</code></pre>
