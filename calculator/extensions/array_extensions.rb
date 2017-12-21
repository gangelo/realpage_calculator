
#
# Convenience extension that converts an array of InputTokens to an array 
# of tokens retrieved from InputToken#token.
class Array
   def to_token_array
      return [] if self.count == 0
      self.map do |input_token| 
         raise ArgumentError, "Array element does not implement method #token" unless input_token.respond_to? :token 
         input_token.token 
      end 
   end
end