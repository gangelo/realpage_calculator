class Object
   # Convenience extension that checks an object for nil or empty.
   #
   # @return [TrueClass, FalseClass] Returns true if the object is 
   # nil? or empty?; false otherwise.
   def blank?
      if self.nil?
         return true
      elsif self.respond_to? :to_s
         return self.to_s.strip.empty?
      elsif self.respond_to? :empty?
         return self.empty?
      else
         return false
      end
   end
end