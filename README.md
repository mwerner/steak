# Steak

## Using Steak

You don't have to touch anything, except the files in the `./bots/` directory. You can create a file for the bot you want to make, and everything else will hook up on it's own.

Bot's are declarative, you can declare some characteristics at the top of the class. The only method you need to provide is `response`.

Example Bot:

    class FooBot < Bot
      observes %r[foo]

      def response
        compose_message(text: 'bar')
      end
    end

This bot will observe all messages, and say `"bar"` whenever the word `foo` is seen.

#### Declarative options
- `username`: The name used when a bot speaks
- `avatar`: The image used for the bot's image
- `description`: A description of the bot's purpose. Provided when calling `/cmd help`
- `observes`: The pattern provided will match against all messages, calling `#response` when there is a match
- `command`: The string of the slash command set up on slack.

You can have both `observes` and `command` on the same bot, for both passive and explicit behavior. Make sure you check the type of behavior requested in the `#response`. You can use `#invoked?` to determine if it was a slash command invocation.

When you specify a `command` on a bot, Steak will add a route to the server to accept a path by the same name to your router. You need to use that same string in your Slack configuration of your slash command.

#### Responses

The `Bot` class provides a helper method `#compose_message`, which accepts a hash of attributes. By passing the `text` attribute, you can specify what the bot posts to the chat room.

The string the `#response` method returns will be sent as a private response to the user that invoked the command.

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
