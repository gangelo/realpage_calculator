require_relative 'io_interface'
require_relative '../support/input_token'

module RealPage
   module Calculator
   
      class ConsoleInterface < IOInterface
         public

         #
         # Starts the process of receiving input. Accept connections, 
         # open files, initial STDIN prompts, etc.
         def accept
            receive
         end

         def accept_async
            raise MustOverrideError
         end

         protected 

         #
         # Receive input from the resource previously accepted.
         # When input is received, it should be processed subsequently.
         def receive
            display_prompt

            while !InputToken.quit?(input = $stdin.gets.chomp)
               calculator_result = self.calculator.compute input
               if calculator_result.error? 
                  $stderr.print "Error: #{calculator_result.error_code.to_s}" 
               elsif calculator_result.quit?
                  respond(calculator_result.result)
                  display_new_line
                  break
               else
                  respond(calculator_result.result)
               end 
               display_prompt true
            end
         end

         #
         # Sends processed input back to the resource previously accepted.
         def respond(output)
            $stdout << output
         end

         private

         def display_prompt(new_line = false)
            display_new_line if new_line
            respond("> ")
         end

         def display_new_line
            respond("\n")
         end
      end

   end
end