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

            input_tokens.each do |input_token|
               if input_token.operator?
                  return self.process_operator(input_token)
               elsif input_token.operand?
                  return self.process_operand(input_token)
               elsif input_token.quit?
                  return OutputToken.new(input_token.token)
               elsif input_token.invalid?
                  return OutputToken.new(input_token.token, ValidInputExpectedError.new) 
               end
            end
         end

         protected

         def process_operator(input_token) 
            if self.input_stack.count < 2
               token = input_token.token
               return OutputToken.new(token, OperandExpectedError.new)
            end

            # Retrieve our operands that will be used as part of our operation
            operand_2 = self.input_stack.pop.token
            operand_1 = self.input_stack.pop.token

            # Formulate the operation, save the result and execute the operation
            result = eval("#{operand_1}#{input_token.token}#{operand_2}")
            
            # The result gets pushed to the input stack for later
            self.input_stack << InputToken.new(result)

            OutputToken.new(result)
         end

         def process_operand(input_token) 
            # Operand get pushed onto the input stack for later
            self.input_stack << input_token
            OutputToken.new(input_token.token)
         end
      end

   end
end