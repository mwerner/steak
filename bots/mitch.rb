class Mitch < Bot
  description 'Ocassional wisdom in the voice of Mitch Hedberg'
  username    'mitch'
  avatar      'http://i.imgur.com/bhDpHHS.jpg'
  observes    /(.*)/

  ONE_LINERS      = JSON.parse(File.read("data/mitch.json"))
  STOP_WORDS      = %w(a able about across after all almost also am among an and any are as at be because been but by can cannot could dear did do does either else ever every for from get got had has have he her hers him his how however i if in into is it its just least let like likely may me might most must my neither no nor not of off often on only or other our own rather said say says she should since so some than that the their them then there these they this tis to too twas us wants was we were what when where which while who whom why will with would yet you your)
  CHANCE_OF_MITCH = 0.1

  def response
    return unless contextual_responses.any? && rand <= CHANCE_OF_MITCH
    compose_message(text: contextual_responses.first)
  end

  private

  def contextual_responses
    ONE_LINERS.shuffle.select do |one_liner|
      mitch_words  = one_liner.gsub(/[^\w\s]/, '').split(' ').delete_if{|w| STOP_WORDS.include?(w)}.sort.uniq
      shared_words = (received_tokens & mitch_words)
      shared_words.length >= 4
    end
  end

  def received_tokens
    incoming_message.text.gsub(/[^\w\s]/, '').split(' ').delete_if{|w| STOP_WORDS.include?(w)}.sort.uniq
  end
end
