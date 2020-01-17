FROM python:2

RUN pip install --upgrade pip

ADD requirements.txt ./
ADD stream_tweets_server.py ./

RUN pip install -U -r requirements.txt
RUN python -m nltk.downloader punkt
