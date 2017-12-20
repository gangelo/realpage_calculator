require_relative '../services/service'
require_relative '../support/rpn_input_parser'
require_relative '../support/must_override_error'

module RealPage
   module Calculators

      class Calculator

         protected

         attr_accessor :input_parser

         public 

         def initialize(input_parser = nil)
            @input_parser = input_parser || RPNInputParser.new
            raise ArgumentError, "input_parser does not implement method #tokenize" unless @input_parser.respond_to? :tokenize
         end

         public

         def calculate(input)
            raise MustOverrideError
         end

      end

   end
end