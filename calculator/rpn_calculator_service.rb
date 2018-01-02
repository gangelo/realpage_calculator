require_relative 'base_classes/calculator_service'
require_relative 'support/calculator_result'
require_relative 'support/rpn_input_parser'
require_relative 'support/input_token'
require_relative 'errors/errors'

module RealPage
  module Calculator

    # Provides Reverse Polish Notation computation services to a given IOInterface
    # object or derived class object.
    class RPNCalculatorService < CalculatorService
      # Initializes an object of this type.
      def initialize
        super RPNInputParser.new
      end

      # Performs a compulation given the input.
      #
      # @param [String] input The input to be used in the computation.
      #
      # @return [CalculatorResult] A CalculatorResult object containing the
      # computation result or error encountered.
      def compute(input)
        # Parse our input into an array of InputTokens.
        input_tokens = input_parser.tokenize(input)
        return notify_observer_result_error("", Errors::Calculator::VALID_INPUT_EXPECTED) if input_tokens.empty?

        result = ""

        # Loop through our input tokens so we can process each one.
        input_tokens.each do |input_token|
          if input_token.operator?
            # We have to have at least 2 operands before we're able to perform a computaton, if
            # we have less than 2 operands, notify with an error.
            return notify_observer_result_error(input_token.token, Errors::Calculator::OPERAND_EXPECTED) if input_stack.count < 2
            # If we have at least 2 operands, perform the computation and return the result.
            result = process_operator(input_token.token)
            next
          elsif input_token.operand?
            # Operands just get added to the input stack until we encounter an operator, then
            # we pop the most recent 2 operands and perform the computation and push the result
            # back on to the input stack as we await the next computation.
            result = process_operand(input_token.token)
            next
          elsif input_token.quit?
            # If we're quitting just ignore it and move on, the interface will deal with it.
            next
          elsif input_token.view_stack?
            result = input_stack.to_s
          elsif input_token.clear_stack?
            result = input_stack.clear.to_s
          elsif input_token.invalid?
            # If we don't have a operator, operand or command, notify with an error.
            return notify_observer_result_error(input_token.token, Errors::Calculator::VALID_INPUT_EXPECTED)
          end
        end

        # Notify with the result.
        notify_observer_result(result)
      end

      protected

      # Performs the processesing necessary when an operator is encountered
      # and returns the result.
      #
      # @param [String] operator The operator to process.
      #
      # @return [Float]
      def process_operator(operator)
        # Pop the most recent 2 operands, perform the computation and push the result
        # back on to the input stack as we await the next computation.
        operand_2 = input_stack.pop
        operand_1 = input_stack.pop

        # Eval the operation, save the computation and return the result.
        result = safe_eval(operator, operand_1, operand_2)

        # The result gets pushed to the input stack for later.
        input_stack << result

        result
      end

      # Performs the processesing necessary when an operand is encountered
      # and returns the input.
      #
      # @param [String] token The operand to process.
      #
      # @return [Float]
      def process_operand(token)
        # Operands just get added to the input stack until we encounter an operator, then
        # we pop the most recent 2 operands and perform the computation and push the result
        # back on to the input stack as we await the next computation.
        input_stack << token
        token
      end

      # Safely performs the computation of two operands given an operator.
      #
      # @param [String] operator The operator to use in the computation.
      # @param [Float] operator_1 The first operator to use in the computation.
      # @param [Float] operator_2 The second operator to use in the conputation.
      #
      # @ returns [Float] Returns the computed result.
      def safe_eval(operator, operand_1, operand_2)
        raise ArgumentError unless InputToken.operator?(operator)
        raise ArgumentError unless InputToken.operand?(operand_1) && InputToken.operand?(operand_2)
        # Floats are objects just like any other class object; we can consequently send a call the
        # operator as a method on the Float object, passing operator_2 as a param. We can get the
        # computed results that way, as opposed to using (unsafe) eval.
        operand_1.public_send(operator, operand_2)
      end
    end

  end
end
