class Scoreboard < Bot
  description "Keeps track of who's winning"
  username    'scorecjh'
  avatar      'http://i.imgur.com/Tjk6mim.jpg'
  observes    /@(.*)(\+\+|\-\-)/
  command     :scoreboard

  def response
    invoked? ? compose_message(text: scores) : adjust_score
  end

  private

  def scores
    Slack::USERNAMES.reduce({}) do |memo, name|
      memo[name] = store.get(name) || 0
      memo
    end.sort{|(_,x),(_,y)| y.to_i <=> x.to_i }
  end

  def adjust_score
    puts matches.inspect
    name, operation = matches
    name = Slack::SLACK_IDS[name.gsub(/\W/, '')]
    return if name.nil? || name == incoming_message.user_name
    score = operation == '--' ? store.decrement(name) : store.increment(name)
    "@#{name} now has a score of #{score}"
  end

  def store
    @store ||= Keystore.new(:scoreboard)
  end
end
