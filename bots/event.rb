class Event < Bot
  command     :event
  description 'An rsvp system for ad hoc events'
  username    'eventcjh'
  avatar      'http://i.imgur.com/mKSWziK.png'

  def response
    'foo'
  end

  private

  def store
    @store ||= Keystore.new(:gifs)
  end
end
