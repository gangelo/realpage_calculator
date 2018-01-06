require 'readline'

require_relative 'base_classes/io_interface'
require_relative 'support/input_token'
require_relative 'i18n/i18n_translator'
require_relative 'support/configuration'

module RealPage
  module Calculator
    # Provides a console interface that uses $stdin and $stdout.
    class ConsoleInterface < IOInterface
      def initialize(calculator_service)
        super
      end

      def accept
        super

        display_prompt

        input = receive
        until closed? || input_parser.quit_command?(input)
          calculator_service.compute(input)
          close if input_parser.contains_quit_command?(input)
          break if closed?
          display_prompt
          input = receive
        end
      end

      protected

      def receive
        if Configuration.instance.use_readline?
          receive_readline
        else
          receive_stdin
        end
      end

      def respond(output)
        $stdout << output
      end

      def respond_error(output)
        $stderr << output
      end

      def receive_calculator_result(calculator_result)
        respond("#{calculator_result.result}\n")
      end

      def receive_calculator_result_error(calculator_result)
        error_label = I18nTranslator.instance.translate(Errors.error_label)
        error_message = I18nTranslator.instance.translate(calculator_result.error, token: calculator_result.result)
        respond_error("#{error_label}: #{error_message}\n")
      end

      def receive_readline
        # Ignore Ctrl-C
        trap('INT', 'SIG_IGN')
        input = Readline.readline
        # If Ctrl-D, input will be nil? Just quit.
        if input.nil?
          respond("\n")
          close
        else
          input.strip
        end
      end

      def receive_stdin
        input = $stdin.gets
        if input.nil?
          respond("\n")
          close
        else
          input.strip
        end
      rescue SystemExit, Interrupt
        # Capture Ctrl-C.
        respond("\n")
        return nil
      end

      def display_prompt(new_line = false)
        new_line ? respond("\n> ") : respond('> ')
      end
    end
  end
end
