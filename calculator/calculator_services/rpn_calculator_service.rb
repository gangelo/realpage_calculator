require_relative 'calculator_service'
require_relative '../support/rpn_input_parser'
require_relative '../support/input_token'

module RealPage
   module Calculator
   
      #
      # Question: Should the Calculator be serializable in the case of a stateless environment that needs to
      # keep track of the calculator input?
      class RPNCalculatorService < CalculatorService

         public 

         def inititialize
            super RPNInputParser.new
         end

         public

=begin
         #
         # Pseudo code RPN processing loop...   
         for each token in the postfix expression:
            if token is an operator:
               operand_2 ← pop from the stack
               operand_1 ← pop from the stack
               result ← evaluate token with operand_1 and operand_2
               push result back onto the stack
            else if token is an operand:
               push token onto the stack
         result ← pop from the stack
=end

         def calculate(input)
            input_tokens = input_parser.tokenize(input)
            return "" if input_tokens.empty?

            result = ""

            input_tokens.each_with_index do |token, index|
               if token.operator?

                  # Retrieve our operands that will be used as part of our operation
                  operand_2 = input_stack.pop.token
                  operand_1 = input_stack.pop.token

                  # Formulate the operation, save the result and execute the operation
                  operation = "#{operand_1}#{token.token}#{operand_2}"
                  result = eval(operation)
                  
                  # The result gets pushed to the input stack for later
                  input_stack << InputToken.new(result)
               elsif token.operand?
                  # Operand get pushed onto the input stack for later
                  input_stack << token
                  result = token.token
               elsif token.quit?
                  result = ""
                  break
               end
            end

            return result

         end

      end
   end
end