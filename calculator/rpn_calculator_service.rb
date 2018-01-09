require_relative 'base_classes/calculator_service'
require_relative 'support/calculator_result'
require_relative 'support/rpn_input_parser'
require_relative 'support/input_token'
require_relative 'errors/errors'
require_relative 'support/helpers'

module RealPage
  module Calculator
    # Provides Reverse Polish Notation computation services.
    class RPNCalculatorService < CalculatorService
      include Helpers::Arrays

      def initialize
        super RPNInputParser.new
      end

      def compute(input)
        input_tokens = input_parser.tokenize(input)
        return notify_error('', Errors::Calculator::VALID_INPUT_EXPECTED) if input_tokens.empty?
        return if input_parser.contains_invalid_tokens?(input_tokens) do |invalid_tokens|
          notify_error(invalid_tokens.join(','), Errors::Calculator::VALID_INPUT_EXPECTED)
        end
        process_loop(input_tokens)
      end

      protected

      def process_loop(input_tokens)
        result = ''
        result_error = nil

        input_tokens.each do |input_token|
          # Ignore quit, it will be handled in the interface.
          next if input_token.quit?

          break if input_error?(input_token) do |error, error_token|
            result = error_token
            result_error = error
          end

          result = process_input_token(input_token)
        end

        # Notify the interface and return the result.
        result_error ? notify_error(result, result_error) : notify(result)
      end

      def input_error?(input_token)
        if input_token.operator? && input_stack.count < 2
          # We have to have at least 2 operands before we're able to perform a
          # computaton, otherwise, this is an error.
          yield Errors::Calculator::OPERAND_EXPECTED, input_token.token
          true
        else
          false
        end
      end

      def process_input_token(input_token)
        case
        when input_token.operator?
          process_operator(input_token.token)
        when input_token.operand?
          process_operand(input_token.token)
        when input_token.command?
          process_command(input_token)
        end
      end

      def process_operator(operator)
        # Pop the most recent 2 operands, perform the computation and push the
        # result back on to the input stack as we await the next computation.
        operand_2 = input_stack.pop
        operand_1 = input_stack.pop

        result = safe_eval(operator, operand_1, operand_2)

        # The result gets pushed to the input stack for subsequent computations
        # unless we've a divide by zero that results in an infinite value, then
        # we do not add that to the input stack.
        input_stack << result unless result.infinite?

        result
      end

      def process_operand(operand)
        # Operands just get added to the input stack until we encounter at least
        # two operands and a operator, then we  perform a computation.
        input_stack << operand
        operand
      end

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

      def safe_eval(operator, operand_1, operand_2)
        raise ArgumentError unless InputToken.operator?(operator)
        raise ArgumentError unless InputToken.operand?(operand_1) && InputToken.operand?(operand_2)
        # Floats are objects just like any other class object; we can
        # consequently send a call to the operator method on the Float object,
        # passing operator_2 as a param to get our results. This is safe unlike
        # eval.
        operand_1.public_send(operator, operand_2)
      end
    end
  end
end
