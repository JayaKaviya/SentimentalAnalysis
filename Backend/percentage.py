import tweepy

from textblob import TextBlob
import pandas as pd
import numpy as np
import re
import matplotlib.pyplot as plt
from flask_cors import CORS
plt.style.use('fivethirtyeight')

from flask import * 
app=Flask(__name__) 
CORS(app)


processjson_cors_config={ 
   
   "origins":["http://127.0.0.1:5000"],
   "methods":["OPTIONS","GET","POST"], 
   "allow-headers":["Authorization","Content-Type"]
} 

CORS( app, resources={ 
   r"/processjson/*" : processjson_cors_config
}
   
)

# Replace with your own X(OlD NAME: TWITTER) account API credentials
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
     
     posts = api.user_timeline(screen_name=username,count=500,lang="en",tweet_mode="extended")
   
     df = pd.DataFrame([tweet.full_text for tweet in posts], columns=['Tweets'])
    
     return df  
   except: 
     return  "error"
   

def clean_tweet(text):
  text = re.sub(r'@[A-Za-z0-9]+', '', text)
  text = re.sub(r'#', '', text)
  text = re.sub(r'RT[\s]+', '', text)
  text = re.sub(r'https?:\/\/S+', '', text)
  text= re.sub(r'\s+', ' ', text)
  text=re.sub(r'http\S+', '', text)
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

@app.route('/processjson',methods=["POST"])
def processjson(): 
    data=request.get_json() 
    name=data['username'] 

    df = get_tweets(name) 
   
    try:
      df['Tweets'] = df['Tweets'].apply(clean_tweet) 

      df['Subjectivity'] = df['Tweets'].apply(getSubjectivity)
      df['Polarity'] = df['Tweets'].apply(getPolarity) 
    
      df['Analysis'] = df['Polarity'].apply(getAnalysis) 

      

      ptweets = df[df.Analysis == 'Positive']
      ptweets = ptweets['Tweets']
      positive = round((ptweets.shape[0]/df.shape[0])*100, 1)
      ntweets = df[df.Analysis == 'Negative']
      ntweets = ntweets['Tweets']
      negative = round((ntweets.shape[0]/df.shape[0])*100, 1)
      neutral = 100-(positive+negative) 
      m=df.head(5)
      #print(m)
      n=m.to_json()
    

      if (positive==0 and negative==0 and neutral==0):
         t="No tweets found in your account Chief ! \n Kindly post tweets and posts to know about your MENTAL HEALTH"
         return jsonify({'req':t})
      else:
        return jsonify({'positive':positive,'negative':negative,'neutral':neutral,'tweet':n})  
      
        
    except:
         a="Kindly Re-enter the valid  TWITTER HANDLE  of your Public Twitter account"
         return jsonify({'req':a}) 


if __name__=="__main__": 
    app.run(debug=True)