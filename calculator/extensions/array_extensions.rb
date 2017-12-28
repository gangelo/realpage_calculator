# Convenience extension that converts an array of InputToken objects to an array 
# of tokens. The tokens in the array are obtained by calling InputToken#token. An
# ArgumentError is raised if any elements do not implement #token.
#
# @return [Array]
class Array
   def to_token_array
      return [] if self.count == 0
      self.map do |input_token| 
         raise ArgumentError, "Array element does not implement method #token" unless input_token.respond_to? :token 
         input_token.token 
      end 
   end
end