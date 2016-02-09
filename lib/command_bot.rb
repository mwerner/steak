require 'lib/bot'

class CommandBot < Bot

  def response
    puts "#{self.class.name}[#{incoming_message.key}]: #{incoming_message.args}"
    command = incoming_message.key.to_s.to_sym
    args = incoming_message.args

    if command.nil?
      # slash command was called bare with no additional parameters
      # e.g.: /gif
      return send(:bare)
    end

    if args.empty?
      # slash command was called with only a bot command
      # e.g.: /gif mytag
      return send(:default, command)
    end

    # slash command was called with a bot command and parameters
    # e.g.: /gif add mytag http://i.imgur.com/V9ejwRi.gif
    validate_command(command)
    send(command, args)
  end

  private

  def validate_command(command)
    return if respond_to?(command)
    raise StandardError, "#{self.class.name} does not implement #{command}"
  end
end
