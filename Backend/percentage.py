import tweepy
from textblob import TextBlob
import pandas as pd
import numpy as np
import re
import matplotlib.pyplot as plt
from flask_cors import CORS
import mysql.connector
from flask import *

plt.style.use('fivethirtyeight')

app = Flask(__name__)
CORS(app)

processjson_cors_config = {
    "origins": ["http://127.0.0.1:5000"],
    "methods": ["OPTIONS", "GET", "POST"],
    "allow-headers": ["Authorization", "Content-Type"]
}

CORS(app, resources={r"/processjson/*": processjson_cors_config})

#Replace with your Twitter developer account's credentials
consumer_key =""
consumer_secret =""
access_token =""
access_token_secret =""


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

# Create API object
api = tweepy.API(auth)

def get_tweets(username):
    try:
        posts = api.user_timeline(screen_name=username, count=500, lang="en", tweet_mode="extended")
        df = pd.DataFrame([tweet.full_text for tweet in posts], columns=['Tweets'])
        return df
    except:
        return "error"

def clean_tweet(text):
    text = re.sub(r'@[A-Za-z0-9]+', '', text)
    text = re.sub(r'#', '', text)
    text = re.sub(r'RT[\s]+', '', text)
    text = re.sub(r'https?:\/\/\S+', '', text)
    text = re.sub(r'\s+', ' ', text)
    text = re.sub(r'http\S+', '', text)
    text = re.sub(r'[^\w\s]', '', text)
    return text

def getSubjectivity(text):
    return TextBlob(text).sentiment.subjectivity

def getPolarity(text):
    return TextBlob(text).sentiment.polarity

def getAnalysis(score):
    if score < 0:
        return 'Negative'
    elif score == 0:
        return 'Neutral'
    else:
        return 'Positive'

def store_tweets_to_db(username, tweets):
    try:
        connection = mysql.connector.connect(
             host='127.0.0.1',
            user='mysql',
            password='mysql',
            database='Twitter'
        )
        cursor = connection.cursor()

        for tweet in tweets:
            
            cursor.execute(
                "SELECT COUNT(*) FROM tweets WHERE username = %s AND tweet = %s",
                (username, tweet)
            )
            exists = cursor.fetchone()[0]

            if exists:
             
                cursor.execute(
                    "UPDATE tweets SET tweet = %s WHERE username = %s AND tweet = %s",
                    (tweet, username, tweet)
                )
            else:
               
                cursor.execute(
                    "INSERT INTO tweets (username, tweet) VALUES (%s, %s)",
                    (username, tweet)
                )

        connection.commit()
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        if (connection.is_connected()):
            cursor.close()
            connection.close()


@app.route('/processjson', methods=["POST"])
def processjson():
    data = request.get_json()
    name = data['username']

    df = get_tweets(name)
    if isinstance(df, str) and df == "error":
        return jsonify({'req': "Error fetching tweets. Please try again."})

    try:
        df['Tweets'] = df['Tweets'].apply(clean_tweet)
        df['Subjectivity'] = df['Tweets'].apply(getSubjectivity)
        df['Polarity'] = df['Tweets'].apply(getPolarity)
        df['Analysis'] = df['Polarity'].apply(getAnalysis)

        # Store tweets to MySQL database
        store_tweets_to_db(name, df['Tweets'].tolist())

        ptweets = df[df.Analysis == 'Positive']
        ptweets = ptweets['Tweets']
        positive = round((ptweets.shape[0] / df.shape[0]) * 100, 1)
        ntweets = df[df.Analysis == 'Negative']
        ntweets = ntweets['Tweets']
        negative = round((ntweets.shape[0] / df.shape[0]) * 100, 1)
        neutral = 100 - (positive + negative)
        m = df.head(5)
        n = m.to_json()

        if positive == 0 and negative == 0 and neutral == 0:
            t = "No tweets found in your account Chief! Kindly post tweets to know about your MENTAL HEALTH."
            return jsonify({'req': t})
        else:
            return jsonify({'positive': positive, 'negative': negative, 'neutral': neutral, 'tweet': n})
    except Exception as e:
        a = f"Kindly re-enter the valid Twitter handle of your public Twitter account. Error: {e}"
        return jsonify({'req': a})

if __name__ == "__main__":
    app.run(debug=True)


