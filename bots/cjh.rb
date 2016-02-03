class Cjh < Bot
  description "Request Beau's take on technology"
  username    'trollcjh'
  avatar      'http://i.imgur.com/w5yXDIe.jpg'
  command     :cjh

  WEIGHTS = {
    pro:     0.1,
    haskell: 0.45,
    taylor:  0.05
  }
  HELP = "/cjh TOPIC                   return beau's opinion on TOPIC"

  def response
    chosen_topic = incoming_message.key || random_technology_topic
    compose_message({
      text: form_opinion(chosen_topic)
    })
  end

  private

  def form_opinion(topic)
    srand()
    rand_value = rand()

    return ":heart: :taylor: :heart:" if rand_value < WEIGHTS[:taylor]
    return "Anyone who doesn't use #{topic.downcase} is nubs." if rand_value < WEIGHTS[:pro]
    return "#{rand_value < WEIGHTS[:haskell] ? 'Learn :haskell:. ' : ''}#{topic.capitalize} sucks. Never use #{topic.downcase}."
  rescue
    "I hate everything."
  end

  def random_technology_topic
    url = "https://en.wikipedia.org/wiki/List_of_buzzwords"
    doc = Nokogiri::HTML(open(url))
    buzzwords = doc.at_css('#Science_and_technology').parent.next_sibling.next_sibling.css('li').collect{|n| n.content}

    # Remove citations
    buzzwords.map!{|b| b.gsub(/\[.+$/, '')}

    # Remove descriptors
    buzzwords.map!{|b| b.split(" - ")[0]}

    buzzwords.shuffle.first
  end
end
