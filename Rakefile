if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  require 'dotenv/tasks'
  Dotenv.load
end

require 'yaml'
require './server'
require 'sinatra/activerecord/rake'

task :bots do
  active_bots = YAML.load_file('config/settings.yml')['bots'].to_a
  if active_bots.empty?
    puts "** All bots active"
  else
    puts "** Active Bots:"
    active_bots.each do |bot|
      puts bot.camelize
    end
  end

  puts "\n** Bot Details:"
  Dir["bots/*.rb"].each do |bot|
    botname = File.basename(bot, '.rb').camelize
    if Object.const_defined?(botname)
      bot_class = Object.const_get(botname)

      puts bot_class.name
      puts "  #{bot_class.description}" if bot_class.description
      if bot_class.observer?
        puts "  Observes: #{bot_class.pattern}"
      elsif bot_class.commandline?
        puts "  Action: /#{bot_class.command}"
      end
      puts
    end
  end
end
