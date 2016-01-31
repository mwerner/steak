require 'lib/bot'

slack = Bot.new(ENV['SLACK_CHANNEL'], ENV['SLACK_INCOMING_PATH'])

ENV['OBSERVERS'].to_s.split(',').each do |observer|
  slack.add_observer(observer)
end

class Application
  @connection = ['Foo']

  def self.connection
    @connection.first
  end

  def self.connection=(value)
    @connection[0] = value
  end
end

Application.connection = slack
