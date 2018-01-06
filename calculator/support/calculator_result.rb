require_relative '../errors/errors'

module RealPage
  module Calculator
    # Provides a container for the result returned from a calculator service
    # computation.
    class CalculatorResult
      attr_reader :result

      alias token result

      # Holds the calculator error encountered, if any.
      attr_reader :error

      def initialize(result, error = Errors::Calculator::NONE)
        raise ArgumentError, 'result parameter is nil' if result.nil?
        raise ArgumentError, 'error is invalid' unless Errors::Calculator.all_errors.include?(error)

        @result = result
        @error = error
      end

      def error?
        error != Errors::Calculator::NONE
      end
    end
  end
end
