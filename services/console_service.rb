require_relative 'service_base'

module RealPage
   module Calculators
   
      class ConsoleService < ServiceBase

         def initialize
         end

         def accept_input
            # TODO: Get the input...
            input = nil
            @calculator.send_result(input)
         end
      end
   end
end