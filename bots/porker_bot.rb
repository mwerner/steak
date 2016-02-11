require 'models/gram'

class PorkerBot < Bot
  command     :porker
  observes    %r[(.*)]
  description "Markov bot that's overly picky"
  username    'porkercjh'
  avatar      'http://i.imgur.com/w5yXDIe.jpg'
  help        '/porker           Send a markov chain based on the conversation'

  attr_reader :sword1, :sword2, :sword3
  TUPLE_LENGTH = 3

  def initialize(*args)
    super
    @sword1, @sword2, @sword3 = "__MARKOV_START_A__", "__MARKOV_START_B__", "__MARKOV_START_C__"
  end

  def response
    invoked? ? compose_message(text: generated_sentence) : record_conversation
  end

  private

  def record_conversation
    return if incoming_message.user_name =~ /porker/i

    words = incoming_message.text.to_s.split(" ")
    return unless words.length > TUPLE_LENGTH

    words.unshift(*%w(__MARKOV_START_A__ __MARKOV_START_B__ __MARKOV_START_C__))
    words.push '__MARKOV_END__'

    (0...(words.length - TUPLE_LENGTH)).each do |i|
      Gram.add(*words[i..(i + TUPLE_LENGTH)])
    end
  end

  def generated_sentence
    phrase = []

    loop do
      next_word = Gram.random_suffix(@sword1, @sword2, @sword3)
      break if next_word == "__MARKOV_END__"

      @sword1, @sword2, @sword3 = @sword2, @sword3, next_word
      phrase.append(next_word)
    end

    phrase.join(' ')
  end
end
