require_relative 'error'

module RealPage
   module Calculator
      #
      # An operand was expected, but 'x' was encountered instead.
      class OperandExpectedError < Error

         def message
            "Error: Operand was expected but '#{self.token}' was encountered."
         end

      end
   end
end