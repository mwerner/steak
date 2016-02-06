class Scoreboard < Bot
  command     :scoreboard
  observes    /@(.*)(\+\+|\-\-)/
  description "Keeps track of who's winning"
  username    'scorecjh'
  avatar      'http://i.imgur.com/Tjk6mim.jpg'
  help        %q(
@username++                Add another point to username's score
@username--                Subtract a point from username's score

/scoreboard                Show the current scores
)

  def response
    return adjusted_score unless invoked?

    compose_message(text: scores.map{|s| s.join(': ')}.join("\n"))
  end

  private

  def scores
    Slack::USERNAMES.reduce({}) do |memo, name|
      memo[name] = store.get(name) || 0
      memo
    end.sort{|(_,x),(_,y)| y.to_i <=> x.to_i }
  end

  def adjusted_score
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
