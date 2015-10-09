In [85]: %timeit sum((randint(0,3) for _ in range(12000000)))
1 loops, best of 3: 16.9 s per loop

In [86]: %timeit sum((np.random.randint(3) for _ in range(12000000)))
1 loops, best of 3: 2.24 s per loop

In [87]: %timeit sum([np.random.randint(3) for _ in range(12000000)])
1 loops, best of 3: 2.08 s per loop

In [88]: %timeit sum([np.random.randint(3) for _ in np.arange(12000000)])
1 loops, best of 3: 3.03 s per loop

%timeit np.sum(np.fromiter([np.random.randint(3) for _ in np.arange(12000000)], int))
1 loops, best of 3: 3.31 s per loop

Ok this is the deal: I basically realised that there is not much more I can do here. I tried using blists and numpy and both do not make the procedure faster. The reason is probably due to the nature of the map-reduce task, that is all the list have to be traversed once and fully, so using a different data structure doesn't change a thing. The only possible thing one can do in this case is to break the function is several threads or processes and recompose it at the end. I'm comparing Haskell with Python and Haskell ain't doing well at all! so I dont' even know if at this point in time it makes sense to carry on with this. Well it is interesting so I suppose it would make sense...
