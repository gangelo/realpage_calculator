require_relative '../errors/errors'

module RealPage
  module Calculator
    # Provides a container for the result returned from a Calculator computation.
    class CalculatorResult
      # Holds the calculator's computed result or calculator output.
      # In the case of an error, it will contain the calculator's initial input.
      attr_reader :result

      # An alias for #result which would make more sense in the case if an error
      # is encountered. In this case, #result would hold the offending input token.
      # Referencing the offending token via #result is misleading.
      alias token result

      # Holds the calculator error encountered, if any.
      attr_reader :error

      # Initializes an object of this type.
      #
      # @param [Object] result the calculator's computed result or calculator output.
      #     In the case of an error, it will contain the calculator's initial input. An
      #     ArgumentError is raised if result is nil.
      #
      # @param [Hash] error the error encountered. This should be an error hasn found in
      #     RealPage::Calculator::Errors::Calculator.all_errors. An ArgumentError is
      #     raised if error is not incuded in RealPage::Calculator::Errors::Calculator.all_errors.
      def initialize(result, error = Errors::Calculator::NONE)
        raise ArgumentError, 'result parameter is nil' if result.nil?
        raise ArgumentError, 'error is invalid' unless Errors::Calculator::all_errors.include?(error)

        @result = result
        @error = error
      end

      # Returns true if the calculator encountered an error; false otherwise.
      #
      # @return [TrueClass, FalseClass]
      def error?
        error != Errors::Calculator::NONE
      end
    end
  end
end
