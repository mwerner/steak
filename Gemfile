source "https://rubygems.org"

ruby '2.2.2'

gem 'sinatra'
gem 'config'
gem 'faraday'
gem 'puma'
gem 'twitter'
gem 'nokogiri'

# Datastore stuff
gem "activerecord"
gem "sinatra-activerecord"
gem 'redis'

group :production do
 gem 'pg'
end

group :development do
  gem 'sqlite3'
  gem 'tux'
  gem 'foreman'
  gem 'shotgun'
  gem 'awesome_print'
  gem 'pry'
end

gem 'dotenv', groups: [:development, :test]
