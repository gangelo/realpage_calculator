require_relative 'input_token'
require_relative '../base_classes/input_parser'
require_relative '../support/configuration'
require_relative '../support/helpers'

module RealPage
  module Calculator
    # Provides input parsing for the RPNCalculatorService.
    class RPNInputParser < InputParser
      def contains_invalid_tokens?(input_token_array)
        return false if blank?(input_token_array)
        invalid_tokens = []
        input_token_array.each do |input_token|
          invalid_tokens << input_token.token if input_token.invalid?
        end
        yield invalid_tokens if invalid_tokens.count > 0
        invalid_tokens.count > 0
      end

      def contains_quit_command?(input)
        return false if blank?(input)
        input.split.include? RealPage::Calculator::Configuration.instance.quit_command
      end

      def quit_command?(input)
        return false if blank?(input)
        input == RealPage::Calculator::Configuration.instance.quit_command
      end

      def self.to_token_array(input_token_array)
        return [] if input_token_array.nil? || input_token_array.count == 0
        input_token_array.map do |input_token|
          raise ArgumentError, 'input_token_array element does not implement method #token' unless input_token.respond_to? :token
          input_token.token
        end
      end

      protected

      def parse(input)
        input.split.map { |t| InputToken.new(t) } || []
      end
    end
  end
end
