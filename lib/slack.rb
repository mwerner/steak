module Slack
  USER_DATA = YAML.load_file('config/settings.yml')['users']
  USERNAMES = USER_DATA.keys.freeze
  SLACK_IDS = USER_DATA.to_a.reverse.to_h.freeze
end
