require 'readline'

require_relative 'base_classes/io_interface'
require_relative 'support/input_token'
require_relative 'i18n/i18n_translator'
require_relative 'support/configuration'

module RealPage
  module Calculator
    # Provides a file interface that processes a file.
    class FileInterface < IOInterface
      protected

      attr_accessor :file

      public

      def initialize(calculator_service)
        super
      end

      def accept(file_name)
        super

        raise ArgumentError, "#{file_name} does not exist" unless File.exist?(file_name)

        @file = File.new("#{Dir.pwd}/#{file_name}", 'r')
        input = receive
        until closed? || input_parser.quit_command?(input)
          calculator_service.compute(input)
          break if closed? || input_parser.contains_quit_command?(input)
          input = receive
        end

        close unless closed?
      end

      protected

      def receive
        if @file.eof?
          close
        else
          @file.gets.strip
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

      def close
        super
        @file.close unless @file.closed?
      end
    end
  end
end
