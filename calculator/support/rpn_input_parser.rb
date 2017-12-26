require_relative 'input_token'
require_relative '../support/configuration'
require_relative '../extensions/array_extensions'

module RealPage
   module Calculator

      class RPNInputParser
         def tokenize(input)
         	return [] if nil_or_empty?(input)
         	parse(input)
         end

         #
         # Converts an array of InputTokens to an array of tokens 
         # retrieved from InputToken#token.
         def self.to_token_array(input_token_array)
            return [] if input_token_array.nil? || input_token_array.count == 0
            input_token_array.map do |input_token| 
               raise ArgumentError, "input_token_array element does not implement method #token" unless token.respond_to? :toke 
               input_token.token 
            end 
         end

         #
         # Returns true if the input contains the quit command; false otherwise.
         def self.contains_quit_command(input)
            return false if input.nil? || input.strip.empty?
            input.split.include? RealPage::Calculator::Configuration.instance.quit_command
         end

         protected

         #
         # This member simply checks to make sure the input is not nil? or empty?.
         def nil_or_empty?(input)
         	input.nil? || input.strip.empty?
         end

         def parse(input)
            input = input.split.map { |t| InputToken.new(t) }
         end
      end
      
   end
end