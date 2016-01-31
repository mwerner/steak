$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'sinatra/activerecord'
require 'pg'
require 'config'
require 'config/environment'
require 'config/initializer'
bot = Application.connection

get '/' do
  return bot.first
end

# post '/message' do
#   message = IncomingMessage.new(params)
#   logger.info "Message! #{message.inspect}"
#   bot.receive(message)

#   # return empty to make sinatra happy
#   ""
# end
