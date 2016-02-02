class DeclarativeClass
  def self.declarable(*attrs)
    attrs.each do |attribute|
      define_singleton_method attribute.to_sym do |value = nil|
        if value.nil?
          defined?(instance_variable_get("@#{attribute}")) ? instance_variable_get("@#{attribute}") : nil
        else
          instance_variable_set("@#{attribute}", value)
        end
      end
    end
  end
end
