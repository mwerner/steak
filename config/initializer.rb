require 'config/application'
channel, path = ENV['SLACK_CHANNEL'], ENV['SLACK_INCOMING_PATH']

Application.connection = Slack::Interface.new(channel, path).tap do |interface|
  Dir['bots/*'].each do |filename|
    botname = File.basename(filename, '.rb')
    next if Settings.bots && !Settings.bots.include?(botname)

    interface.register_bot(botname)
  end
end
