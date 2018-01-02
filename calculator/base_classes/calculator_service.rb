require_relative '../support/rpn_input_parser'
require_relative '../errors/must_override_error'
require_relative '../errors/errors'

module RealPage
  module Calculator
    # Provides a base for calculators. Classes inheriting CalculatorService are responsible
    # for overriding the #compute method in order to provide computation specific to the
    # calculator in question.
    class CalculatorService
      protected

      # Holds input to the calculator in a stack.
      attr_accessor :input_stack

      # Holds a reference to an IOInterface object responsible for sending CalculatorService
      # output in the form of a CalculatorResult object to the output stream.
      attr_reader :interface_observer

      public

      # Holds a reference to the object responsible for parsing input specific to the calculator's
      # input format needs.
      attr_accessor :input_parser

      # Initializes an object of this type.
      #
      # @param [Object] input_parser A reference to an IOInterface object responsible for sending CalculatorService
      #     output in the form of a CalculatorResult object to the output stream. An ArgumentError is raised
      #     if input_parser is nil or an empty String.
      def initialize(input_parser)
        raise ArgumentError, 'input_parser is nil or empty' if input_parser.nil? || input_parser.to_s.empty?
        @input_stack = []
        @input_parser = input_parser
        @interface_observer = nil
      end

      # Performs a compulation given the input. This method needs to be overridden.
      #
      # @param [String] input The input to be used in the computation.
      #
      # @return [CalculatorResult] This method, when overridden, should return
      # a CalculatorResult object.
      def compute(_input)
        raise MustOverrideError
      end

      # Clears the @input_stack
      def clear
        @input_stack = []
      end

      # Registers the given IOInterface object for notifications. Output from a CalculatorService should ultimately
      # be passed to #notify_observer_result and/or #notify_observer_result_error for processing.
      #
      # @param [IOInterface] interface_observer An IOInterface, or derived class object to be notified when the
      #     CalculatorService is ready to send output back to the interface.
      def attach_observer(interface_observer)
        @interface_observer = interface_observer
      end

      protected

      # Notifies the @interface_observer by passing a CalculatorResult if @interface_observer is not nil.
      #
      # @param [CalculatorResult] calculator_result A CalculatorResult object to be sent to the
      #     @interface_observer's #receive_calculator_result method.
      #
      # @return [CalculatorResult]
      def notify_observer_result(calculator_result)
        calculator_result = CalculatorResult.new(calculator_result, Errors::Calculator::NONE)
        @interface_observer.send(:receive_calculator_result, calculator_result) unless @interface_observer.nil?
        # Return the calculator result as it makes life a little easier for testing.
        calculator_result
      end

      # Notifies the @interface_observer by passing a CalculatorResult if @interface_observer is not nil.
      #
      # @param [CalculatorResult] calculator_result A CalculatorResult object to be sent to the
      #     @interface_observer's #receive_calculator_result_error method. CalculatorResult#error will contain
      #     the error encountered, along with the offending input contained in CalculatorResult#token.
      #
      # @return [CalculatorResult]
      def notify_observer_result_error(calculator_result, calculator_error)
        calculator_result = CalculatorResult.new(calculator_result, calculator_error)
        @interface_observer.send(:receive_calculator_result_error, calculator_result) unless @interface_observer.nil?
        # Return the calculator result as it makes life a little easier for testing.
        calculator_result
      end
    end
  end
end
