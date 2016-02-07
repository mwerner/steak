class DeclarativeClass
  def self.declarable(*attrs)
    attrs.each do |attribute|
      define_singleton_method "set_#{attribute}".to_sym do |value|
        instance_variable_set("@#{attribute}", value)
      end

      define_singleton_method "get_#{attribute}".to_sym do
        defined?(instance_variable_get("@#{attribute}")) ? instance_variable_get("@#{attribute}") : nil
      end

      define_singleton_method attribute.to_sym do |value = nil|
        value.nil? ? send("get_#{attribute}") : send("set_#{attribute}", value)
      end
    end
  end
end
