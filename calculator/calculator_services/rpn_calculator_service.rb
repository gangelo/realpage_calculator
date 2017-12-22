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
            return OutputToken.new("", ValidInputExpectedError.new) if input_tokens.empty?

            result = ""

            input_tokens.to_token_array.each do |token|
               if InputToken.operator?(token)
                   if self.input_stack.count < 2
                     return OutputToken.new(token, OperandExpectedError.new)
                  end
                  result = self.process_operator(token)
               elsif InputToken.operand?(token)
                  result = self.process_operand(token)
               elsif InputToken.quit?(token)
                  result = token
               elsif InputToken.invalid?(token)
                  return OutputToken.new(token, ValidInputExpectedError.new) 
               end
            end

            OutputToken.new(result)
         end

         protected

         def process_operator(operator) 
            # Retrieve our operands that will be used as part of our operation
            operand_2 = self.input_stack.pop
            operand_1 = self.input_stack.pop

            # Formulate the operation, save the result and execute the operation
            result = eval("#{operand_1}#{operator}#{operand_2}")
            
            # The result gets pushed to the input stack for later
            self.input_stack << result

            result
         end

         def process_operand(token) 
            # Operand get pushed onto the input stack for later
            self.input_stack << token
            token
         end
      end

   end
end