set :public_folder, File.dirname(__FILE__) + '/public'
set :root, File.dirname(__FILE__)
register Config

# SLACK_CONFIG = YAML.load_file("config/slack.yml")
Settings.my_config_entry

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

%w(controllers models).each do |dir|
  Dir["#{dir}/*.rb"].each{|file| require file }
end
