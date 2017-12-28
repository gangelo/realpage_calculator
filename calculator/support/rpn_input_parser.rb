require_relative 'input_token'
require_relative '../support/configuration'
require_relative '../extensions/array_extensions'

module RealPage
   module Calculator

      # Provides input parsing capabilities suitabe for an RPNCalculatorService object.
      class RPNInputParser

         # Converts input into a suitable format to be used by an RPNCalculatorService objext.
         #
         # @param [String] input The input to tokenize.
         #
         # @return [Array<InputToken>, []] Returns an Array of InputTokens or an empty 
         # array if input is nil? or empty?
         def tokenize(input)
         	return [] if self.nil_or_empty?(input)
         	self.parse(input)
         end

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
               raise ArgumentError, "input_token_array element does not implement method #token" unless token.respond_to? :toke 
               input_token.token 
            end 
         end

         # Returns true if the input contains the quit command; false otherwise.
         #
         # @param [String, Float] input The input to be interrogated.
         #
         # @return [TrueClass,FlaseClass] Returns true if input is a quit command; false otherwise.
         def self.contains_quit_command?(input)
            return false if input.nil? || input.respond_to?(:to_s) ? input.to_s.strip.empty? : false
            input.split.include? RealPage::Calculator::Configuration.instance.quit_command
         end

         protected

         # This member simply checks to make sure the input is not nil? or empty?.
         #
         # @param [String, Float] input The input to be interrogated.
         #
         # @return [TrueClass, FalseClass] Returns true if input is nil? or empty?; false otherwise.
         def nil_or_empty?(input)
         	input.nil? || input.respond_to?(:to_s) ? input.to_s.strip.empty? : false
         end

         # Parses the input and returns an Array comprised of InputTokens.
         #
         # @param [String, Float] input The input to be interrogated.
         #
         # @return [Array<InputToken> Returns an Array of InputTokens
         def parse(input)
            input = input.split.map { |t| InputToken.new(t) }
         end
      end
      
   end
end