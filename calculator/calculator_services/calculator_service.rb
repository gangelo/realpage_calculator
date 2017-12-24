require_relative '../support/rpn_input_parser'
require_relative '../errors/must_override_error'
require_relative '../errors/calculator_error_codes'

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

            @input_parser = input_parser
            @input_stack = []
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

         def notify_observer_result(calculator_result, quit = false)
            @interface_observer.send(:receive_result, CalculatorResult.new(calculator_result, CalculatorErrorCodes::NONE, quit))
         end

         def notify_observer_error(calculator_result, calculator_error, quit = false)
            @interface_observer.send(:receive_error, CalculatorResult.new(calculator_result, calculator_error, quit))
         end
      end

   end
end