require_relative 'interface_base'

module RealPage
   module Calculators
   
      class ConsoleInterface < InterfaceBase

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