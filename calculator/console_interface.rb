require 'readline'

require_relative 'base_classes/io_interface'
require_relative 'support/input_token'
require_relative 'i18n/i18n_translator'
require_relative 'support/configuration'

module RealPage
   module Calculator
   
      # Provides a console interface that obtains user input from $stdin to be processed by a 
      # CalculatorService or derived class object and returned to the $stdout output stream. 
      class ConsoleInterface < IOInterface
         # Initializes an object of this type.
         #
         # @param [CalculatorService] calculator_service A CalculatorService or derived class object
         # that this interface will use to compute input and receive output from in order to
         # send back to the output stream.
         def initialize(calculator_service)   
            super

            # This is strictly here to remove the task name that Rake inserts
            # when running this script as a task. This will be needed as well
            # if we process any files from the command-line.
            # ARGV.shift
         end

         # Starts the process of receiving input from $stdin and sets the interface state to 
         # the #opened_state.
         def accept
            super

            display_prompt

            input = self.receive
            while !self.closed? && !InputToken.quit?(input)
               self.calculator_service.compute input
               self.close if RPNInputParser.contains_quit_command?(input)
               if !self.closed?
                  self.display_prompt
                  input = self.receive
               end
            end
         end

         # Provides and alias to the #accept method which is a little more intuative
         # in the case of a console interface than it may be for WebSocket, TcpSocket
         # or file.
         alias_method :run, :accept

         def accept_async
            raise MustOverrideError
         end

         protected 

         # Receives input from $stdin.
         #
         # @return [String] Returns the input received with new line characters removed.
         def receive
            if Configuration.instance.use_readline
               self.receive_readline
            else
               self.receive_stdin
            end
         end

         # Sends processed output to the output stream. 
         #
         # @param [Object] output This method sends the output passed to $stdin.
         def respond(output)
            $stdout << output
         end

         # Sends an error to the appropriate error output stream. 
         #
         # @param [Object] output This method sends the output passed to $stderr.
         def respond_error(output)
            $stderr << output
         end

         # Receives a CalculatorResult from a CalculatorService or derived class object via 
         # notification as a result of attaching this interface to @calculator_service as an observer.
         # When @calculator_service input is received, it should be subsequently passed to
         # the interface output stream.
         #
         # @param [CalculatorResult] calculator_result A CalculatorResult object that contains the CalculatorService 
         # result to send to the output stream.
         def receive_calculator_result(calculator_result)
            self.respond("#{calculator_result.result}\n")
         end

         # Receives a CalculatorResult from a CalculatorService or derived class object via 
         # notification as a result of attaching this interface to @calculator_service as an observer.
         # When a @calculator_service error is encountered, it should be subsequently passed to 
         # the interface error output stream.
         #
         # @param [CalculatorResult] calculator_result A CalculatorResult object that contains the CalculatorService 
         # error to send to the error output stream.
         def receive_calculator_result_error(calculator_result)
            # Get the error label to prefix the error message.
            error_label = I18nTranslator.instance.translate(Errors.error_label)
            # Get the error message to send.
            error_message = I18nTranslator.instance.translate(calculator_result.error, { token: calculator_result.result })
            # Interpolate the error label and error message so that it's formatted nicely for display, in the user's locale.
            self.respond_error("#{error_label}: #{error_message}\n")
         end

         protected

         # Receives input from Readline#readline.
         #
         # @return [String] Returns the input received with new line characters and leading, trailing spaces removed.
         def receive_readline
            # Ignore Ctrl-C
            trap("INT", "SIG_IGN")
            input = Readline.readline
            # If Ctrl-D, input will be nil? Just quit.
            if input.nil?
               self.respond "\n"
               return Configuration.instance.quit_command
            end
            input.strip
         end

         # Receives input from $stdin.
         #
         # @return [String] Returns the input received with new line characters and leading, trailing spaces removed.
         def receive_stdin
            input = $stdin.gets 
            if input.nil?
               self.respond "\n"
               return Configuration.instance.quit_command
            end
            input.strip
         rescue SystemExit, Interrupt
            # Capture Ctrl-C.
            self.respond "\n"
            return nil
         end

         # Displays the input prompt.
         #
         # @param [TrueClass, FalseClass] new_line If new_line is true, a new line character will
         # be added before the prompt is displayed; the prompt will be displayed on the same line otherwise.
         #
         def display_prompt(new_line = false)
            new_line ? self.respond("\n> ") : self.respond("> ")
         end
      end

   end
end