require 'lib/slack/channel'

class Bot
  attr_reader :channel, :observers

  def initialize(channel, path)
    # @channel = Slack::Channel.new(channel, path)
    @observers = []
  end

  def first
    "Hello World"
  end

  def add_observer(name)
    # observer = name.capitalize!
    # return unless Object.const_defined?(observer)

    # channel.add_message_observer(Object.const_get(observer_klass))
  end
end
