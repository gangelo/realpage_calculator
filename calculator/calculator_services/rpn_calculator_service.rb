require_relative 'calculator_service'
require_relative 'calculator_result'
require_relative '../support/rpn_input_parser'
require_relative '../support/input_token'
require_relative '../errors/errors'

module RealPage
   module Calculator
   
      # Provides Reverse Polish Notation computation services to a given IOInterface 
      # object or derived class object.
      class RPNCalculatorService < CalculatorService
         public 

         # Initializes an object of this type.
         def initialize
            super RPNInputParser.new
         end

         public

         # Performs a compulation given the input.
         #
         # @param [String] input The input to be used in the computation.
         #
         # @return [CalculatorResult] A CalculatorResult object containing the
         # computation result or error encountered.
         def compute(input)
            # Parse our input into an array of InputTokens.
            input_tokens = self.input_parser.tokenize(input)
            if input_tokens.empty?
               return self.notify_observer_result_error("", Errors::Calculator::VALID_INPUT_EXPECTED)
            end

            # Convert our InputTokens into an array of token values.
            token_array = input_tokens.to_token_array

            result = ""

            # Loop through our tokens so we can process each one.
            token_array.each do |token|
               if InputToken.operator?(token)
                  if self.input_stack.count < 2
                     return self.notify_observer_result_error(token, Errors::Calculator::OPERAND_EXPECTED)
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
                  return self.notify_observer_result_error(token, Errors::Calculator::VALID_INPUT_EXPECTED)
               end
            end

            self.notify_observer_result(result)
         end

         protected

         # Performs the processesing necessary when an operator is encountered
         # and returns the result.
         #
         # @param [String] operator The operator to process.
         #
         # @return [Float]
         def process_operator(operator) 
            # Retrieve our operands that will be used as part of our operation
            operand_2 = self.input_stack.pop
            operand_1 = self.input_stack.pop

            # Eval the operation, save the computation and return the result
            result = self.safe_eval(operator, operand_1, operand_2)
            
            # The result gets pushed to the input stack for later
            self.input_stack << result

            result
         end

         # Performs the processesing necessary when an operand is encountered
         # and returns the input.
         #
         # @param [String] token The operand to process.
         #
         # @return [Float]
         def process_operand(token) 
            # Operand get pushed onto the input stack for later
            self.input_stack << token
            token
         end

         def safe_eval(operator, operand_1, operand_2)
            raise ArgumentError unless InputToken.operator?(operator)
            raise ArgumentError unless InputToken.operand?(operand_1) && InputToken.operand?(operand_2)
            operand_1.public_send(operator, operand_2)
         end
      end

   end
end