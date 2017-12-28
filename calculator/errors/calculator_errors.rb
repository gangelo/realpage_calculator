module RealPage
   module Calculator

      module CalculatorErrors 
         # No error.
         NONE = { key: :none, scope: [:errors, :calculator] }

         # An operand was expected but 'xyz' was encountered.
         OPERAND_EXPECTED = { key: :operand_expected, scope: [:errors, :calculator] }

         # A valid operator, operand, or input terminating sequence was expected but 'xyz' was encountered.
         VALID_INPUT_EXPECTED = { key: :valid_input_expected, scope: [:errors, :calculator] }

         Errors = [NONE, OPERAND_EXPECTED, VALID_INPUT_EXPECTED]
      end

   end
end