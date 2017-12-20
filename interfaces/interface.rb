
require_relative '../support/errors'
require_relative '../support/must_override_error'

module RealPage
   module Calculators
      
      #
      # CalculatorInterfaces are responsible for...
      #
      # 1) Maintaining the state of their own input.
      # 2) Passing input along to the calculator for processing.
      #
      module Interface

         protected

         attr_accessor :calculator

         public

         def attach_calculator(calculator)
            @calculator = calculator
         end

         # 
         # This member sents the result back to the consumer.
         #
         # Note the implementor of this module should format the result accordingly
         # (e.g. json, xml, string, etc.) based on the consumer's expectations.
         def send_result(calculator_result)
            raise MustOverrideError
         end

         #
         # Send error to the consumer.      
         #
         # Note the implementor of this module should format the error accordingly
         # (e.g. json, xml, string, etc.) based on the consumer's expectations.
         def send_error(calculator_error)
            raise MustOverrideError
         end

         protected

         #
         # Notifies the subscribers that an action has taken place.
         def notify
            raise MustOverrideError
         end

      end
   end
end