# Derpy

## Getting Started

#### Environment

`DATABASE_URL`:
`OBSERVERS`:
`SLACK_CHANNEL`:
`SLACK_INCOMING_PATH`:


Run:

  bundle install REDISCLOUD_URL="[redis-url]" SLACK_CHANNEL="[your-channel-here]" SLACK_INCOMING_PATH="[incoming-path-here]" bundle exec shotgun config.ru

To access,

  curl -v http://0.0.0.0:9292/gif?text=money

## Deploying

  git push heroku master
