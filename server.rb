$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'sinatra/activerecord'
require 'pg'
require 'config'
require 'config/environment'
require 'config/initializer'
require 'tilt/erb'

# Instance of lib/slack/interface.rb
connection = Application.connection

# This block will read all the configured bots in ./bots. Any
# bots that have a `command` declared, will be loaded
# here as a POST route with the same named action, passed to
# the connection.
Bot.all.each do |bot|
  next unless bot.commandline?

  post "/#{bot.command}" do
    puts "Processing: #{bot.command} #{params}"
    connection.receive(bot.command, params)
  end
end

post '/message' do # The observer routes
  connection.receive(params)
end

get '/style' do
  erb 'layouts/style'.to_sym, layout: 'layouts/application'.to_sym
end

get '/' do
  erb 'bots/index'.to_sym, layout: 'layouts/application'.to_sym, locals: {bots: Bot.all}
end

# Developer Convenience Routes
if !settings.production?
  Bot.all.each do |bot|
    next unless bot.commandline?

    get "/#{bot.command}" do
      connection.receive(bot.command, params)
    end
  end

  get "/message" do
    connection.receive(params)
  end
end
