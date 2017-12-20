require_relative '../services/service'
require_relative '../support/input_parser'
require_relative '../support/must_override_error'

module RealPage
   module Calculators

      class CalculatorBase

         private 

         attr_accessor :service

         public

         def calculate(input)
            raise MustOverrideError
         end

      end

   end
end