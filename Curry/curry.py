def curry_pair(fun, first): return lambda second: fun(first, second)

def curry_2(fun, first):
    def wrapper(*args, **kwargs):
        return fun(first, *args, **kwargs)
    return wrapper


#@curry_2
def add(x, y): return x+y
