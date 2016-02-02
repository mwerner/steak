$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'sinatra/activerecord'
require 'pg'
require 'config'
require 'config/environment'
require 'config/initializer'

# Instance of lib/slack/interface.rb
connection = Application.connection

# This block will read all the configured bots. Any
# bots that have a `command` declared, will be loaded
# here as a POST route with the same named action, passed to
# the connection.
Dir["bots/*.rb"].each do |bot|
  botname = File.basename(bot, '.rb').camelize
  if Object.const_defined?(botname)
    bot_class = Object.const_get(botname)
    if bot_class.commandline?
      get "/#{bot_class.command}" do
        connection.receive(bot_class.command, params)
      end
    end
  end
end

# The base route handles observers
get '/' do
  connection.receive(params)
end
