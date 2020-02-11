# TwitterSentimentDocker

This demo is a simple yet powerful illustration of several components of the DataStax Enterprise (DSE) Database Platform.

You will connect in to a real time Twitter API feed and using **DSE Real-Time Streaming Analytics** ingest tweets and do some simple transformations before saving to 2 tables in DSE. Then Banana Dashboard will take advantage of **DSE Search** capabilities to provide a view into the real time data flowing into DSE; Facilitating adhoc searches to explore and 'slice & dice' this data. Finally, using **DSE Analytics for batch processing** via DSE GraphFrames, this data will be transformed into a Graph structure and loaded into **DSE Graph** - where **DSE Studio** can be used to visualize the Twitter Sentiment data.

The steps that follow assume you have Docker installed and running. You also need to have a Twitter account so you can generate the necessary keys to connect to the Twitter API (see  https://developer.twitter.com/en/docs/basics/developer-portal/overview)

STEPS
=====

1. From within the **TwitterSentimentDocker** Directory - clone Banana Dashboard repository and copy default.json file to the dashboard template directory,

```
git clone https://github.com/Lucidworks/banana && ( cp default.json banana/src/app/dashboards/ || echo "Did you run this command in the TwitterSentimentDocker directory?" )
```

2. Download and Run DSE container,

```
sudo docker run -p 9042:9042 -p 8983:8983 -v "$PWD":/config -e DS_LICENSE=accept --name my-dse -d datastax/dse-server:6.7.7 -s -k -g
```

3. Create CQL Schema for Twitter data and Banana Dashboard,

```
sudo docker exec -it my-dse bash cqlsh --file '/config/schema.cql'
```

4. Build Python Twitter Streaming app container,

```
sudo docker build -t aregis/twitterapi:1.0 .
```

5. Start up Twitter Streaming app,

```
sudo docker run -p 10002:10002 -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp aregis/twitterapi:1.0 python stream_tweets_server.py --terms="brexit" --access-token="<ACCESS_TOKEN>" --access-secret="ACCESS_SECRET" --consumer-key="<CONSUMER_KEY>" --consumer-secret="<CONSUMER_SECRET>" --address=0.0.0.0 --port=10002
```

6. Connect to the Twitter Streaming app using DSE Pyspark to ingest tweets,

```
sudo docker exec -it my-dse bash
dse pyspark
```

Copy & paste the contents of **pyspark_script.py** into the Pyspark shell

THAT'S IT!

Open up your browser and goto **\<IP_Address_of_Docker_Host\>**:8983/banana to see your real-time streaming Twitter Sentiment Data visualized in the Banana Dasbhboard


Visualising in DSE Graph
========================

1. Create session on DSE container,

```sudo docker exec -it my-dse bash```

2. Execute Graph schema creation script,
 
```dse gremlin-console -e /config/graph.schema```

3. Load Cassandra data into Graph structure,

```dse spark -i /config/scala_loadgraph_script.txt```

4. Startup DSE Studio,

```sudo docker run -e DS_LICENSE=accept --link my-dse --name my-studio -p 9091:9091 -d datastax/dse-studio:6.7.0```

To access the graph goto <IP_ADDRESS>:9091 in your browser. Update the connection to have the IP of the DSE container (i.e 172.17.0.2) and create a new Notebook with "twittergraph" chosen from the drop down list of graphs.
