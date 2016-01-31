class Pong < Bot
  username 'pongbot'
  avatar   'http://imgur.com/MeYf2Ee.jpg'
  action   :ping

  def response
    compose_message({
      icon_emoji: ':light_rail:',
      text: 'PONG'
    })
  end
end
