# TwitterSentimentDocker

This demo is a simple yet powerful illustration of several components of the DataStax Enterprise (DSE) Database Platform.

You will connect in to a real time Twitter API feed and using DSE Real-Time Streaming Analytics ingest tweets and do some simple transformations before saving to 2 tables in DSE. Then Banana Dashboard will take advantage of DSE Search capabilities to provide a view into the real time data flowing into DSE; Facilitating adhoc searches to explore and 'slice & dice' this data. Finally, using DSE Analytics for batch processing via DSE GraphFrames, this data will be transformed into a Graph structure and loaded into DSE Graph - where DSE Studio can be used to visualize the Twitter Sentiment data.

The steps that follow assume you have Docker installed and running.
