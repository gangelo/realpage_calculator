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
            if !super
               # TODO: Return error
               print 'stream is closed'
               return false
            end

            display_prompt

            while !self.closed? && !InputToken.quit?(input = $stdin.gets.chomp)
               self.calculator.compute input
               display_prompt unless self.closed?
            end
         end

         def accept_async
            raise MustOverrideError
         end

         protected 

         #
         # Receive input from the resource previously accepted.
         # When input is received, it should be processed subsequently.
         def receive_result(calculator_result)
            respond(calculator_result.result)
            display_new_line
            self.close if calculator_result.quit?
         end

         def receive_error(calculator_result)
            $stderr.print "Error: #{calculator_result.error_code.to_s}" 
            display_new_line
            self.close if calculator_result.quit?
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