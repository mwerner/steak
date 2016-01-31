$:.unshift File.dirname(__FILE__)
require 'sinatra'
require 'sinatra/activerecord'
require 'pg'
require 'config'
require 'config/environment'
require 'config/initializer'
connection = Application.connection

get '/' do
  connection.receive(params)
end

get '/message' do
  connection.receive(:message, params)
end
