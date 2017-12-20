require_relative '../interfaces/interface'
require_relative '../support/input_parser'
require_relative '../support/must_override_error'

module RealPage
   module Calculators

      class CalculatorBase

         private 

         attr_accessor :interface

         public 

         def initialize(interface)
            @interface = interface
            @interface.attach_calculator(self)
         end

         public

         def calculate(input)
            raise MustOverrideError
         end

      end

   end
end