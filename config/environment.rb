if ENV['RACK_ENV'] && ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

set :root, File.expand_path(File.join(__dir__, '..'))
set :public_folder, File.expand_path(File.join(settings.root, 'public'))

register Config
Config.load_and_set_settings('config/schema.yml')

configure :production, :development do
  db = URI.parse(ENV['DATABASE_URL'] || "postgres://localhost/steak_#{ENV['RACK_ENV']}")

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
