class Object
  # Convenience extension that checks an object for nil or empty.
  #
  # @return [TrueClass, FalseClass] Returns true if the object is
  # nil? or empty?; false otherwise.
  def blank?
    return true if nil?
    if respond_to? :to_s
      return to_s.strip.empty?
    elsif respond_to? :empty?
      return empty?
    else
      return false
    end
  end
end
