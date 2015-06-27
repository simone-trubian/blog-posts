#! /home/simone/CS/twit/bin/python3
from datetime import datetime as dt
import time

from yaml import (load,
                  dump)
from cassandra.cluster import Cluster
from twython import Twython


TIME_STRING = '%a %b %d %X %z %Y'


class TwitterCassandraConnector(object):
    cluster = None
    session = None

    def create_schema(self):
        trending_tweets_keyspace = \
            """CREATE KEYSPACE IF NOT EXISTS trending
            WITH REPLICATION = { 'class': 'SimpleStrategy',
            'replication_factor': 1 };"""

        trending_tweets_table = \
            """CREATE TABLE IF NOT EXISTS trending.tweets(

            name                TEXT,
            promoted_content    BOOLEAN,
            query               TEXT,
            url                 TEXT,
            number_zeros        INT,
            total_retweets      INT,
            max_retweets        INT,
            newest_tweet_time   TIMESTAMP,
            oldest_tweet_time   TIMESTAMP,

            creation_day        TIMESTAMP,
            creation_minute     TIMESTAMP,
            created_at          TIMEUUID,

            PRIMARY KEY( (creation_day), created_at )
            )
            WITH CLUSTERING ORDER BY (created_at DESC);"""

        self.session.execute(trending_tweets_keyspace)
        self.session.execute(trending_tweets_table)

    def log(self, params):

        tweet_insert_query = """INSERT INTO trending.tweets(
                name,
                promoted_content,
                query,
                url,
                number_zeros,
                total_retweets,
                max_retweets,
                newest_tweet_time,
                oldest_tweet_time,
                creation_day,
                creation_minute,
                created_at)
                VALUES(
                '{name}',
                {promoted_content},
                '{query}',
                '{url}',
                {number_zeros},
                {total_retweets},
                {max_retweets},
                '{newest_tweet_time}',
                '{oldest_tweet_time}',
                '{creation_day}',
                '{creation_minute}',
                NOW());"""

        self.session.execute(tweet_insert_query.format(**params))

    def connect(self, host):
        self.cluster = Cluster(host)
        self.session = self.cluster.connect()

    def close(self):
        self.cluster.shutdown()


def get_current_minute():
    now = dt.utcnow()
    current_dt = dt(now.year,
                    now.month,
                    now.day,
                    now.hour,
                    now.minute)

    current_timestamp = (
        time.mktime(dt.timetuple(current_dt)))

    return int(current_timestamp * 1000)


def get_current_day():
    now = dt.utcnow()
    current_dt = dt(now.year,
                    now.month,
                    now.day)
    current_timestamp = (
        time.mktime(dt.timetuple(current_dt)))

    return int(current_timestamp * 1000)


def to_timestamp(date):
    return int(dt.timestamp(dt.strptime(date, TIME_STRING))) * 1000


if __name__ == '__main__':

    # Retrieve keys from configuration file
    with open('twitter_keys.yaml', 'r') as file:
        keys = load(file)

    # Retreive access token if not present.
    if not keys['ACCESS_TOKEN']:
        tw = Twython(keys['APP_KEY'], keys['APP_SECRET'], oauth_version=2)
        keys['ACCESS_TOKEN'] = tw.obtain_access_token()

        with open('twitter_keys.yaml', 'w') as file:
            file.write(dump(keys))

    else:
        tw = Twython(keys['APP_KEY'], access_token=keys['ACCESS_TOKEN'])

    # Retrieve treding topics
    latest_trends = tw.get_place_trends(id=keys['LONDON_WHOEID'])
    latest_trends = latest_trends[0]['trends']

    # Query latest tweets for trending topics and format them according to the
    # Cassandra schema.
    tweets_data = []

    for topic in latest_trends:
        tweets = tw.search(q=topic['query'], count=50)
        tweets = tweets['statuses']
        retweets = [x['retweet_count'] for x in tweets]

        current_day = get_current_day()
        current_minute = get_current_minute()

        tweets_data.append(
            {'name': topic['name'],
             'promoted_content': True if topic['promoted_content'] else False,
             'query': topic['query'],
             'url': topic['url'],
             'total_retweets': sum(retweets),
             'max_retweets': max(retweets),
             'number_zeros': len([x for x in retweets if x == 0]),
             'newest_tweet_time': to_timestamp(tweets[0]['created_at']),
             'oldest_tweet_time': to_timestamp(tweets[-1]['created_at']),
             'creation_day': current_day,
             'creation_minute': current_minute})

    # Open a connection to Cassandra and write the tweet data.
    cluster = TwitterCassandraConnector()
    cluster.connect(['127.0.0.1'])
    cluster.create_schema()
    for obj in tweets_data:
        cluster.log(obj)
    cluster.close()
