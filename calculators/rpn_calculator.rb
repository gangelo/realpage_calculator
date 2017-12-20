require_relative 'calculator'
require_relative '../services/service'
require_relative '../support/rpn_input_parser'

module RealPage
   module Calculators
   
      #
      # Question: Should the Calculator be serializable in the case of a stateless environment that needs to
      # keep track of the calculator input?
      class RPNCalculator < Calculator

         def inititialize
            super RPNInputParser.new
         end

         public

         def calculate(input)
         end

      end

   end
end