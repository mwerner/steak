class Gram < ActiveRecord::Base
  def self.add(word1, word2, word3, suffix)
    if self.where(word1: word1, word2: word2, word3: word3).exists?
      Gram.connection.execute("UPDATE grams SET suffixes = array_append(suffixes, #{ActiveRecord::Base.connection.quote(suffix)}) WHERE word1 = #{ActiveRecord::Base.connection.quote(word1)} AND word2 = #{ActiveRecord::Base.connection.quote(word2)} AND word3 = #{ActiveRecord::Base.connection.quote(word3)};")
    else
      Gram.create(word1: word1, word2: word2, word3: word3, suffixes: [suffix])
    end
  end

  def self.random_suffix(word1, word2, word3)
    where(word1: word1, word2: word2, word3: word3).select("id, suffixes[ceil(random()*array_length(suffixes, 1))] as random_suffix").first.try(:random_suffix)
  end
end

class Porker < Bot
  command     :porker
  observes    /(.*)/
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
