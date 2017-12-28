require_relative '../support/rpn_input_parser'
require_relative '../errors/must_override_error'
require_relative '../errors/errors'

module RealPage
   module Calculator

      class CalculatorService
         protected

         attr_accessor :input_stack
         attr_accessor :input_parser
         attr_reader :interface_observer

         public 

         def initialize(input_parser)
            raise ArgumentError, "input_parser is nil or empty" if input_parser.nil? || input_parser.to_s.empty?
            @input_stack = []
            @input_parser = input_parser
            @interface_observer = nil
         end

         public

         def compute(input)
            raise MustOverrideError
         end

         def clear
            @input_stack = []
         end

         def attach_observer(interface_observer)
            @interface_observer = interface_observer
         end

         protected

         def notify_observer_result(calculator_result)
            calculator_result = CalculatorResult.new(calculator_result, Errors::Calculator::NONE)
            @interface_observer.send(:receive_calculator_result, calculator_result) unless @interface_observer.nil?
            calculator_result
         end

         def notify_observer_result_error(calculator_result, calculator_error)
            calculator_result = CalculatorResult.new(calculator_result, calculator_error)
            @interface_observer.send(:receive_calculator_result_error, calculator_result) unless @interface_observer.nil?
            calculator_result
         end
      end

   end
end