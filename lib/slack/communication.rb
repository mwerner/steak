module Slack
  class Communication
    def initialize(attributes = {})
      attributes.each{|k,v| send("#{k}=", v) }
    end

    def self.attributes(*attrs)
      if attrs.empty?
        return @attributes if defined?(@attributes)
        raise ArgumentError, "You must provide an array of attributes"
      end

      @attributes = [*attrs].flatten.map(&:to_sym).freeze
      self.send(:attr_accessor, *@attributes)
    end

    def payload
      Hash.new.tap do |payload|
        self.class.attributes.each do |attribute|
          value = send(attribute)
          next unless value

          payload[attribute] = value
        end
      end
    end

    def to_json(options = {})
      payload.to_json
    end
  end
end
