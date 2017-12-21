require_relative 'calculator_service'
require_relative '../support/rpn_input_parser'
require_relative '../support/input_token'
require_relative '../support/output_token'
require_relative '../errors/errors'

module RealPage
   module Calculator
   
      #
      # Question: Should the Calculator be serializable in the case of a stateless environment that needs to
      # keep track of the calculator input?
      class RPNCalculatorService < CalculatorService

         public 

         def initialize
            super RPNInputParser.new
         end

         public

         def calculate(input)
            input_tokens = input_parser.tokenize(input)
            return "" if input_tokens.empty?

            result = ""

            input_tokens.each do |input_token|
               if input_token.operator?
                  return self.process_operator(input_token)
               elsif input_token.operand?
                  result = self.process_operand(input_token)
               elsif input_token.quit?
                  result = input_token.token
                  break
               end
            end

            return OutputToken.new(result)

         end

         protected

         def process_operator(input_token) 
            if self.input_stack.count < 2
               token = input_token.token
               return OutputToken.new(token, OperandExpectedError.new(token))
            end

            # Retrieve our operands that will be used as part of our operation
            operand_2 = self.input_stack.pop.token
            operand_1 = self.input_stack.pop.token

            # Formulate the operation, save the result and execute the operation
            operation = "#{operand_1}#{input_token.token}#{operand_2}"
            result = eval(operation)
            
            # The result gets pushed to the input stack for later
            self.input_stack << InputToken.new(result)

            OutputToken.new(result)
         end

         def process_operand(input_token) 
            # Operand get pushed onto the input stack for later
            self.input_stack << input_token
            return input_token.token
         end

         def valid_input_for_state?(input_token)
            # If we've encountered there must be at least 2 operands in the
            # input stack; otherwise, this is an error.
            return false if input_token.operator? && self.input_stack.count < 2
            true
         end

      end
   end
end