require_relative '../support/rpn_input_parser'
require_relative '../errors/must_override_error'

module RealPage
   module Calculator

      class CalculatorService

         protected

         attr_accessor :input_stack
         attr_accessor :operand_stack
         attr_accessor :operator_stack
         attr_accessor :input_parser

         public 

         def initialize(input_parser)
            raise ArgumentError, "input_parser is nil or empty" if input_parser.nil? || input_parser.to_s.empty?

            @input_parser = input_parser
            @input_stack = []
            @operand_stack = []
            @operator_stack = []
         end

         public

         def calculate(input)
            raise MustOverrideError
         end

      end

   end
end