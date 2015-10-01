from nltk.corpus import reuters as re

def get_test_set():
    single_categories = [(id, re.categories(id)[0])
                         for id in re.fileids()
                         if len(re.categories(id)) == 1]

    single_cat_list = distribution(single_categories, itemgetter(1))
    used_categories = [x[0]
                       for x in single_cat_list
                       if x[1] < 600 and x[1] > 200]

    return [pair for pair in single_categories if pair[1] in used_categories]
