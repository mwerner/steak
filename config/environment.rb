if ENV['RACK_ENV'] && ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

set :public_folder, File.dirname(__FILE__) + '/public'
set :root, File.dirname(__FILE__)

register Config
Config.load_and_set_settings('config/settings.yml')

configure :production, :development do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/steak')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

require 'lib/slack/communication'
%w(lib bots).each do |dir|
  Dir["#{dir}/**/*.rb"].each{|file| require file }
end
