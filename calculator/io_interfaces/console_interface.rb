require_relative 'io_interface'

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

            while !(output_token = self.calculator.calculate $stdin.gets.chomp).quit?
               if output_token.error? 
                  $stderr.print output_token.error.message 
               else
                  respond(output_token.token)
               end
               display_prompt true
            end
         end

         #
         # Sends processed input back to the resource previously accepted.
         def respond(output)
            $stdout.print output
         end

         private

         def display_prompt(new_line = false)
            respond("\n") if new_line
            respond("> ")
         end
      end
   end
end