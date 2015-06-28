def get_velocity(tweet):
    """
    Given a captured trending tweet data structure, the function returns the
    "velocity" of the thread, that is the number of tweets per minute.
    """

    diff = tweet['newest_tweet_time'] - tweet['oldest_tweet_time']
    return 0 if diff.total_seconds() == 0 else 60 / diff.total_seconds()
