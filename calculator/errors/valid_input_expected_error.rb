require_relative 'error'

module RealPage
   module Calculator

      #
      # An operand was expected, but 'x' was encountered instead.
      class ValidInputExpectedError < Error
         def message
            "A valid operator, operand, or input terminating sequence was expected but '#{self.token}' was encountered."
         end
      end
      
   end
end