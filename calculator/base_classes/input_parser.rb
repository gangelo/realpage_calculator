require_relative '../support/input_token'
require_relative '../support/configuration'
require_relative '../extensions/array_extensions'
require_relative '../extensions/object_extensions'
require_relative '../errors/must_override_error'

module RealPage
   module Calculator

      # Provides input parsing capabilities suitabe for an RPNCalculatorService object.
      class InputParser

         # Converts input into a suitable format to be used by an RPNCalculatorService objext.
         #
         # @param [String] input The input to tokenize.
         #
         # @return [Array<Object>, []] Returns an Array of Objects or an empty 
         # array if input is nil? or empty? The array element object types depends
         # on the #parse method implementation that must be overridden.
         def tokenize(input)
            return [] if input.blank?
            self.parse(input)
         end

         # Returns true if the input contains the quit command; false otherwise.
         #
         # @param [Object] input The input to be interrogated.
         #
         # @return [TrueClass,FlaseClass] Returns true if input is a quit command; false otherwise.
         def self.contains_quit_command?(input)
            return false if input.blank?
            input.split.include? RealPage::Calculator::Configuration.instance.quit_command
         end

         protected

         # Parses the input and returns the parsed output. This method must be overridden.
         #
         # @param [Object] input The input to be parsed.
         #
         # @return [Object] Should return the parsed input.
         def parse(input)
            raise MustOverrideError
         end
      end
      
   end
end