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
            super

            display_prompt

            while !self.closed? && !InputToken.quit?(input = self.receive)
               self.calculator.compute input
               self.display_prompt unless self.closed?
            end

         end

         def accept_async
            raise MustOverrideError
         end

         protected 

         #
         # Receives input from the stream previously accepted.
         def receive
            input = $stdin.gets
            input.chomp
         end

         #
         # Sends processed output to the stream previously accepted.
         def respond(output)
            $stdout << output
         end

         #
         # Receives the calculator result from the calculator via 
         # notification as a result of attaching to the calculator as an observer.
         # When calculator input is received, it should be subsequently
         # passed to the interface output stream.
         def receive_calculator_result(calculator_result)
            self.respond("#{calculator_result.result}\n")
            self.close if calculator_result.quit?
         end

         #
         # Receives the calculator result error from the calculator via
         # notification as a result of attaching to the calculator as an observer.
         # When calculator input error is received, it should be subsequently
         # passed to the interface error output stream.
         def receive_calculator_result_error(calculator_result)
            $stderr << "Error: #{calculator_result.error_code.to_s}\n" 
            self.close if calculator_result.quit?
         end

         protected

         def display_prompt(new_line = false)
            new_line ? respond("\n> ") : respond("> ")
         end
      end

   end
end