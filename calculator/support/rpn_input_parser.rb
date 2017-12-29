require_relative 'input_token'
require_relative '../base_classes/input_parser'
require_relative '../support/configuration'
require_relative '../extensions/array_extensions'
require_relative '../extensions/object_extensions'

module RealPage
   module Calculator

      # Provides input parsing capabilities suitabe for an RPNCalculatorService object.
      class RPNInputParser < InputParser

         # Converts an array of InputTokens to an array of tokens comprised ot 
         # InputToken#token.
         #
         # @param [Array<InputToken>] input_token_array An array of InputTokens to
         # be converted.
         #
         # @return [Array<String, Float>] Returns an array of mixed tokens comprised of
         # Strings and/or Floats if token is InputToken.operand?(token).
         def self.to_token_array(input_token_array)
            return [] if input_token_array.nil? || input_token_array.count == 0
            input_token_array.map do |input_token| 
               raise ArgumentError, "input_token_array element does not implement method #token" unless input_token.respond_to? :token 
               input_token.token 
            end 
         end

         protected

         # Parses the input and returns an Array comprised of InputTokens.
         #
         # @param [String, Float] input The input to be parsed.
         #
         # @return [Array<InputToken> Returns an Array of InputTokens.
         def parse(input)
            input = input.split.map { |t| InputToken.new(t) }
         end
      end
      
   end
end