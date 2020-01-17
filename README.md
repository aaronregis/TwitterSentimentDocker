# TwitterSentimentDocker

This demo is a simple yet powerful illustration of several components of the DataStax Enterprise (DSE) Database Platform.

You will connect in to a real time Twitter API feed and using **DSE Real-Time Streaming Analytics** ingest tweets and do some simple transformations before saving to 2 tables in DSE. Then Banana Dashboard will take advantage of **DSE Search** capabilities to provide a view into the real time data flowing into DSE; Facilitating adhoc searches to explore and 'slice & dice' this data. Finally, using **DSE Analytics for batch processing** via DSE GraphFrames, this data will be transformed into a Graph structure and loaded into **DSE Graph** - where **DSE Studio** can be used to visualize the Twitter Sentiment data.

The steps that follow assume you have Docker installed and running.

STEPS
=====

1. Run setup script to create directory structure, download repositories and place relevent files in respective locations,

```
./setup.sh
```

2. Download and Run DSE container,

```
sudo docker run -p 9042:9042 -p 8983:8983 -v /home/ds_user/dse/conf:/config -e DS_LICENSE=accept --name my-dse -d datastax/dse-server:6.7.7 -s -k -g
```

3. Create CQL Schema,

```
sudo docker exec -it my-dse bash cqlsh --file '/config/TwitterSentiment/schema.cql'
```

4. Build Python Twitter Streaming app container,

```
sudo docker build -t aregis/twitterapi:1.0 ./TwitterSentimentDocker/
```

5. Start up Twitter Streaming app container,

```
sudo docker run -p 10002:10002 -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp aregis/twitterapi:1.0 python dse/conf/TwitterSentiment/stream_tweets_server.py --terms="brexit" --access-token="<ACCESS_TOKEN>" --access-secret="ACCESS_SECRET" --consumer-key="<CONSUMER_KEY>" --consumer-secret="<CONSUMER_SECRET>" --address=0.0.0.0 --port=10002
```

6. Connect to the Twitter Streaming app using DSE Pyspark to ingest tweets,

```
sudo docker exec -it my-dse bash
dse pyspark
```

Copy & Paster contents of **pyspark_script.py** into Pyspark shell
