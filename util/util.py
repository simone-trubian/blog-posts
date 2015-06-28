from itertools import groupby
from operator import itemgetter

def distribution(data, keyfun=None):
    data = sorted(data, key=keyfun)
    groups = []
    uniquekeys = []

    for key, group in groupby(data, keyfun):
        groups.append(list(group))
        uniquekeys.append(key)

    groups = [len(group) for group in groups]
    distribution = list(zip(uniquekeys, groups))

    return distribution
