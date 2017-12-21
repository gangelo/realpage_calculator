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

         def initialize(input_parser = nil)
            @input_parser = input_parser || RPNInputParser.new
            raise ArgumentError, "input_parser does not implement method #tokenize" unless @input_parser.respond_to? :tokenize

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