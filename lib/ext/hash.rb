class Hash
  def to_params
    self.to_a.map{|(k,v)| "#{k}=#{v}" }.join('&')
  end
end
