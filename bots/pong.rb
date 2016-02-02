class Pong < Bot
  description 'Responds "PONG" to the /ping command'
  username    'pongbot'
  avatar      'http://i.imgur.com/bSao1fE.png'
  command     :ping

  def response
    compose_message({
      icon_emoji: ':light_rail:',
      text: 'PONG'
    })
  end
end
