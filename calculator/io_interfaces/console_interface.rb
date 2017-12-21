require_relative 'io_interface'

module RealPage
   module Calculator
   
      class ConsoleInterface < IOInterface

         public

         #
         # Starts the process of receiving input. Accept connections, 
         # open files, initial STDIN prompts, etc.
         def accept
            display_prompt
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
            while !(output_token = calculator.calculate $stdin.gets.chomp).quit?
               respond(output_token)
               display_prompt
            end
         end

         #
         # Sends processed input back to the resource previously accepted.
         def respond(output)
            $stdout.print output
         end

         private

         def display_prompt
            respond("> ")
         end
      end
   end
end