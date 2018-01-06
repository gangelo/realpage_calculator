require_relative '../support/input_token'
require_relative '../support/configuration'
require_relative '../support/helpers'
require_relative '../errors/must_override_error'

module RealPage
  module Calculator
    # Base class for all input parsers.
    class InputParser
      include Helpers::Blank

      def tokenize(input)
        return [] if blank?(input)
        parse(input)
      end

      # Should return true if input contains any invalid tokens.
      def contains_invalid_tokens?(_input)
        raise MustOverrideError
      end

      # Should return true if input contains one of more 'quit' commands.
      def contains_quit_command?(_input)
        raise MustOverrideError
      end

      # Should return true if input is the 'quit' command.
      def quit_command?(_input)
        raise MustOverrideError
      end

      protected

      # Should parse and return input suitable for consumption by the
      # CalculatorService.
      def parse(_input)
        raise MustOverrideError
      end
    end
  end
end
