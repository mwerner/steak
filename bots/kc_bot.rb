require "twitter"

class KcBot < Bot
  command     :kc
  description 'KC Tweets'
  username    'kc'
  avatar      'http://i.imgur.com/PFmJs43.png'
  help        '/kc          Get a random tweet from some guy with KC for initials.'

  ACCOUNT_NAME = "kc_advice"
  NUMBER_OF_TWEETS = 200
  CONSUMER_KEY = "pqAHeAczxGlq1m0K7V4WRnOgj"
  CONSUMER_SECRET = ENV["TWITTER_CONSUMER_SECRET"]
  ACCESS_TOKEN = "23369679-mAKj448qj40u3in93Ldw6HkooiOKspxnUwRNsloA7"
  ACCESS_SECRET = ENV["TWITTER_ACCESS_SECRET"]

  def response
    compose_message(text: selected_tweet)
  end

  private

  def selected_tweet
    @tweets ||= twitter_client.user_timeline(ACCOUNT_NAME, :count => NUMBER_OF_TWEETS)
    @tweets.sample.text
  end

  def twitter_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = CONSUMER_KEY
      config.consumer_secret     = CONSUMER_SECRET
      config.access_token        = ACCESS_TOKEN
      config.access_token_secret = ACCESS_SECRET
    end
  end
end
