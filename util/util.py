from itertools import groupby


def group(data, keyfun=None):
    data = sorted(data, key=keyfun)
    groups = []
    uniquekeys = []

    for key, group in groupby(data, keyfun):
        groups.append(list(group))
        uniquekeys.append(key)

    return dict(zip(uniquekeys, groups))


def distribution(data, keyfun=None):

    groups = group(data, keyfun)

    for key in groups:
        groups[key] = len(groups[key])

    return groups
