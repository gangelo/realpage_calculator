require_relative 'io_interface'

module RealPage
   module Calculator
   
      class ConsoleInterface < IOInterface

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