require_relative 'io_interface'
require_relative '../support/input_token'

#require 'byebug'

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

            input = self.receive
            while !self.closed? && !InputToken.quit?(input)
               self.calculator.compute input
               self.close if RPNInputParser.contains_quit_command(input)
               if !self.closed?
                  self.display_prompt
                  input = self.receive
               end
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
         end

         #
         # Receives the calculator result error from the calculator via
         # notification as a result of attaching to the calculator as an observer.
         # When calculator input error is received, it should be subsequently
         # passed to the interface error output stream.
         def receive_calculator_result_error(calculator_result)
            $stderr << "Error: #{calculator_result.error_code.to_s}\n"
         end

         protected

         def display_prompt(new_line = false)
            new_line ? respond("\n> ") : respond("> ")
         end
      end

   end
end