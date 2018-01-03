require_relative '../support/input_token'
require_relative '../support/configuration'
require_relative '../support/helpers'
require_relative '../errors/must_override_error'

module RealPage
  module Calculator
    # Provides input parsing capabilities suitabe for an RPNCalculatorService
    # object.
    class InputParser
      include Helpers::Blank

      # Converts input into a suitable format to be used by an
      # RPNCalculatorService objext.
      #
      # @param [String] input The input to tokenize.
      #
      # @return [Array<Object>, []] Returns an Array of Objects or an empty
      # array if input is nil? or empty? The array element object types depends
      # on the #parse method implementation that must be overridden.
      def tokenize(input)
        return [] if blank?(input)
        parse input
      end

      # Returns true if the input contains the quit command; false otherwise.
      # This method must be overridden.
      #
      # @param [Object] input The input to be interrogated.
      #
      # @return [TrueClass, FlaseClass] Returns true if input is a quit command;
      # false otherwise.
      def contains_quit_command?(_input)
        raise MustOverrideError
      end

      # Returns true if the input equals the quit command; false otherwise.
      # This method must be overridden.
      # This member is differant than the #contains_quit_command? member in that
      # input is not split into a token array and Array#include? used to see if
      # input is a token within the token array. Rather, this is simply
      # a == comparison.
      #
      # @param [Object] input The input to be interrogated.
      #
      # @return [TrueClass, FlaseClass] Returns true if input is a quit command;
      # false otherwise.
      def quit_command?(_input)
        raise MustOverrideError
      end

      protected

      # Parses the input and returns the parsed output. This method must be
      # overridden.
      #
      # @param [Object] input The input to be parsed.
      #
      # @return [Object] Should return the parsed input.
      def parse(_input)
        raise MustOverrideError
      end
    end
  end
end
