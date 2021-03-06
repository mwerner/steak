class String
  def blank?
    self.nil? || self == ''
  end

  def camelize
    self.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end
end
