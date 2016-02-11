class PongBot < Bot
  command     :ping
  description 'Responds "PONG" to the /ping command'
  username    'pongbot'
  avatar      'http://i.imgur.com/bSao1fE.png'
  help        '/ping          Bot will PONG if connected properly'

  def response
    compose_message({
      icon_emoji: ':light_rail:',
      text: 'PONG'
    })
  end
end
