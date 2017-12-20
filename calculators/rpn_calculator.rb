require_relative 'calculator_base'
require_relative '../interfaces/interface'
require_relative '../support/input_parser'

module RealPage
   module Calculators
   
      #
      # Question: Should the Calculator be serializable in the case of a stateless environment that needs to
      # keep track of the calculator input?
      class RPNCalculator < CalculatorBase

         def inititialize
         #   super(interface)
         end

         public

         def calculate(input)
         end

      end

   end
end