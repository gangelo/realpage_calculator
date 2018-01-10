require_relative '../support/rpn_input_parser'
require_relative '../errors/must_override_error'
require_relative '../errors/messages'

module RealPage
  module Calculator
    # Base for all calculator services.
    class CalculatorService
      protected

      attr_accessor :input_stack

      # IOInterface reference for communicating with the stream.
      attr_reader :interface_observer

      public

      attr_accessor :input_parser

      def initialize(input_parser)
        raise ArgumentError, 'input_parser is nil or empty' if input_parser.nil? || input_parser.to_s.empty?
        @input_parser = input_parser
        @input_stack = []
        @interface_observer = nil
      end

      def compute(_input)
        raise MustOverrideError
      end

      def clear
        @input_stack = []
      end

      def attach_observer(interface_observer)
        @interface_observer = interface_observer
      end

      protected

      def notify(calculator_result)
        calculator_result = CalculatorResult.new(calculator_result,
                                                 { message: CalculatorErrors.none})
        @interface_observer.send(:receive_calculator_result, calculator_result) unless @interface_observer.nil?
        # Return the calculator result as it makes life a little easier for
        # testing.
        calculator_result
      end

      def notify_error(calculator_result, calculator_error)
        calculator_result = CalculatorResult.new(calculator_result,
                                                 { message: calculator_error })
        @interface_observer.send(:receive_calculator_result_error, calculator_result) unless @interface_observer.nil?
        # Return the calculator result as it makes life a little easier for
        # testing.
        calculator_result
      end

      # Should return true if processing _token will cause a divide by zero
      # scenario resulting in Float#infinite?.
      def will_divide_by_zero?(_token)
        raise MustOverrideError
      end
    end
  end
end
