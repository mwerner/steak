# Steak

## Environment

`REDISCLOUD_URL`: For heroku

`RACK_ENV`: `[development, production]`

`SLACK_CHANNEL`: `#fuuu`

`SLACK_INCOMING_PATH`: Incoming webhooks path ex: `/services/T09L19D91/B0CMHUACB/2TCE5yv123K8rsOH3M70gcpVL`

Found at: slack.com/apps/manage/custom-integrations

`SLACK_TEAM`: 'teamsubdomain'

## Getting Started

Run:

  cp .env.example .env
  bundle install
  bundle exec shotgun config.ru

To access,

  curl -v http://0.0.0.0:9292/gif?text=money

## Deploying

  git push heroku master
