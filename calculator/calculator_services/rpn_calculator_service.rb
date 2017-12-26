require_relative 'calculator_service'
require_relative 'calculator_result'
require_relative '../support/rpn_input_parser'
require_relative '../support/input_token'
require_relative '../errors/calculator_error_codes'

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

         def compute(input)
            input_tokens = self.input_parser.tokenize(input)
            if input_tokens.empty?
               return self.notify_observer_result_error("", CalculatorErrorCodes::VALID_INPUT_EXPECTED)
            end

            token_array = input_tokens.to_token_array

            result = ""

            token_array.each do |token|
               if InputToken.operator?(token)
                  if self.input_stack.count < 2
                     return self.notify_observer_result_error(token, CalculatorErrorCodes::OPERAND_EXPECTED)
                  else
                     result = self.process_operator(token)
                     next
                  end
               elsif InputToken.operand?(token)
                  result = self.process_operand(token)
                  next
               elsif InputToken.quit?(token)
                  # If we're quitting just ignore it and move on, the interface will deal with it.
                  next
               elsif InputToken.view_stack?(token)
                  result = self.input_stack.to_s
               elsif InputToken.clear_stack?(token)   
                  result = self.input_stack.clear.to_s
               elsif InputToken.invalid?(token)
                  return self.notify_observer_result_error(token, CalculatorErrorCodes::VALID_INPUT_EXPECTED)
               end
            end

            self.notify_observer_result(result)
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