# Optimization with large datasets.

Python and Haskell might seem like worlds apart. One is object-oriented, the other purely functional, one is dynamic the other static, one is interpreted the other compiled. Yet I find the two languages to have a similar feel: they both have a clan syntax, prefer a declarative approach to programming and provide high-level constructs.
In this post we're going to try both languages in a mapreduce-like job, the kind of work that is often necessary to do when analysing large amounts of data. However the task is a bit contrived it works as a good example and is very simple to understand. The job consists of reading a text file containing 12 million rows, filtering out the ones that are too short and too long, counting the number of Capital letters in it and then calculating the total number of letters.

An interesting aspect of mapreduce which is in some respects reminiscent of old school batch jobs, is that in many cases it only requires an initial IO phase to gather data and is concluded with a final IO phase to return the result. In between the two phases there can be an enormous amount of computation that is mostly pure. Furthermore it is the type of computation that often allows for parallelisation of the tasks. This is one of the reason why in my opinion functional languages can be a good fit for this type of computation.

A standard Python implementation could be something like
