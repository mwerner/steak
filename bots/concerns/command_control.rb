module CommandControl
  def send_command
    command = incoming_message.key.to_s.to_sym
    args = incoming_message.args

    if command.blank?
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

  def validate_command(command)
    return true if respond_to?(command)
    raise StandardError, "#{self.class.name} does not implement #{command}"
  end

  def controls_commands?
    true
  end
end
