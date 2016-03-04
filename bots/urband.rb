require 'open-uri'

class Urband < Bot
  description 'Returns a definition from Urban Dictionary dot com'
  username    'urbanD'
  avatar      'http://i.imgur.com/2AO4Xn7.png'
  command     :urband
  HELP = "/urband [WORD] Look up the WORD on urban dictionary"

  API_ENDPOINT = "http://api.urbandictionary.com/v0/define"

  def response
    return "No definition... SORRY, NOT SORRY" unless definition

    compose_message.tap do |message|
      message.attachments << Slack::MessageAttachment.new({
        title: "#{incoming_message.user_name} defines #{term} for you all, you're welcome:",
        fallback:  "#{incoming_message.user_name} defined #{term}",
        text: definition
      })
    end
  end

  private

  def results
    JSON.parse(api_response)['list'] || []
  end

  def definition
    entry = results.first
    return unless entry
    entry['definition']
  end

  def api_response
    open("#{API_ENDPOINT}?term=#{term}").read || '{}'
  end

  def term
    incoming_message.text
  end
end
