module RealPage
   module Calculator

      module CalculatorErrorCodes 
         # No error.
         NONE = 0

         # An operand was expected but 'xyz' was encountered."
         OPERAND_EXPECTED = 1

         # A valid operator, operand, or input terminating sequence was expected but 'xyz' was encountered.
         VALID_INPUT_EXPECTED = 2

         Codes = [NONE, OPERAND_EXPECTED, VALID_INPUT_EXPECTED]
      end

   end
end