mkdir -p dse/conf && cd dse/conf

git clone https://github.com/aaronregis/TwitterSentimentDocker
git clone https://github.com/Lucidworks/banana

cp dse/conf/TwitterSentiment/server.xml dse/conf/server.xml
cp dse/conf/TwitterSentiment/default.json dse/conf/banana/src/app/dashboards/
