require 'faraday'

module Slack
  class Channel
    attr_reader :name, :incoming_path, :interface

    def initialize(interface, name, path)
      @interface = interface
      @name = name

      raise ArgumentError, 'You must define SLACK_INCOMING_PATH in your environment' if path.nil?
      @incoming_path = path
    end

    def post(message)
      response = connection.post do |req|
        req.url incoming_path
        req.headers['Content-Type'] = 'application/json'
        req.body = message.to_json
      end

      if response.status != 200
        puts "Non-Successful Response: #{response.env.body}"
      end

      response
    end

    private

    def connection
      @connection = Faraday.new(url: 'https://hooks.slack.com') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
