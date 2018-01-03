require_relative 'base_classes/calculator_service'
require_relative 'support/calculator_result'
require_relative 'support/rpn_input_parser'
require_relative 'support/input_token'
require_relative 'errors/errors'
require_relative 'support/helpers'

module RealPage
  module Calculator
    # Provides Reverse Polish Notation computation services to a given
    # IOInterface object or derived class object.
    class RPNCalculatorService < CalculatorService
      include Helpers::Arrays

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
        return notify_error('', Errors::Calculator::VALID_INPUT_EXPECTED) if input_tokens.empty?
        return if input_parser.contains_invalid_tokens?(input_tokens) do |invalid_tokens|
          notify_error(invalid_tokens.join(','), Errors::Calculator::VALID_INPUT_EXPECTED)
        end
        compute_loop(input_tokens)
      end

      protected

      def compute_loop(input_tokens)
        result = ''
        calculator_result = nil

        # Loop through our input tokens so we can process each one.
        input_tokens.each_with_index do |input_token, index|
          if input_token.operator? && input_stack.count < 2
            # We have to have at least 2 operands before we're able to perform a
            # computaton, if we have less than 2 operands, notify with an error.
            calculator_result = notify_error(input_token.token, Errors::Calculator::OPERAND_EXPECTED) if input_stack.count < 2
            break
          end

          process_input_token(input_token) do |results|
            result = results
          end

          calculator_result = notify(result) if upper_bound(input_tokens) == index
        end

        calculator_result
      end

      # Processes an input token and yields the result
      #
      # @param [InputToken] input_token The InputToken object to process.
      def process_input_token(input_token)
        result =
          case
          when input_token.quit?
            # If we're quitting just ignore it and move on, the interface will
            # deal with it.
            return
          when input_token.operator?
            # If we have at least 2 operands, perform the computation and return
            # the result.
            process_operator(input_token.token)
          when input_token.operand?
            # Operands just get added to the input stack until we encounter an
            # operator, then we pop the most recent 2 operands and perform the
            # computation and push the result back on to the input stack as we
            # await the next computation.
            process_operand(input_token.token)
          when input_token.command?
            process_command(input_token)
          end
        yield result
      end

      # Performs the processesing necessary when an operator is encountered
      # and returns the result.
      #
      # @param [String] operator The operator to process.
      #
      # @return [Float]
      def process_operator(operator)
        # Pop the most recent 2 operands, perform the computation and push the
        # result
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
      # @param [String] operand The operand to process.
      #
      # @return [Float]
      def process_operand(operand)
        # Operands just get added to the input stack until we encounter an
        # operator, then
        # we pop the most recent 2 operands and perform the computation and
        # push the result
        # back on to the input stack as we await the next computation.
        input_stack << operand
        operand
      end

      # Returns the result of running the command.
      #
      # @param [InputToken] command The InputCommand to process.
      #
      # @return [String] Returns the results of the command in String form.
      def process_command(command)
        result =
          case
          when command.view_stack?
            input_stack.to_s
          when command.clear_stack?
            input_stack.clear.to_s
          end
        result
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
        # Floats are objects just like any other class object; we can
        # consequently send a call the operator as a method on the Float object,
        # passing operator_2 as a param. We can get the computed results that
        # way, as opposed to using (unsafe) eval.
        operand_1.public_send(operator, operand_2)
      end
    end
  end
end
