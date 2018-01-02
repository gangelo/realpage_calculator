require_relative '../support/configuration'

module RealPage
  module Calculator
    # Provides a class that represents an individual, space delimited token received from
    # an IOInterface.
    class InputToken
      # A Hash list of valid operators.
      @@operators = nil

      # A Hash list of valid commands.
      @@commands = nil

      # Initializes an object of this type.
      #
      # @param [String] token The token value.
      def initialize(token = nil)
        @token = token
      end

      #--
      # Instance methods
      #++

      # Sets the token.
      #
      # @param [Object] value The value to set #token to.
      def token=(value)
        @token = value
      end

      # Returns the token value.
      #
      # @return [Float, Object] Returns the token as a Float
      # if the token is an operand; returns the token othewise.
      def token
        InputToken.operand?(@token) ? Float(@token) : @token
      end

      # Returns true or false based on whether or not token is an operator.
      #
      # @return [TrueClass, FalseClass] returns true if token is an operator; false otherwise.
      def operator?
        InputToken.operator?(@token)
      end

      # Returns true or false based on whether or not token is an operand.
      #
      # @return [TrueClass, FalseClass] returns true if token is an operand; false otherwise.
      def operand?
        InputToken.operand?(@token)
      end

      # Returns true or false based on whether or not token is a command.
      #
      # @return [TrueClass, FalseClass] returns true if token is a command; false otherwise.
      def command?
        InputToken.command?(@token)
      end

      # Returns true or false based on whether or not token is an operator, operand or command.
      #
      # @return [TrueClass, FalseClass] returns true if token is an operator, operand or command; false otherwise.
      def valid?
        InputToken.valid?(@token)
      end

      # Returns true or false based on whether or not token is a operator, operand or command.
      #
      # @return [TrueClass, FalseClass] returns true if token is not an operator, operand or command; false otherwise.
      def invalid?
        !InputToken.valid?(@token)
      end

      # Returns true or false based on whether or not token is nil? or empty?.
      #
      # @return [TrueClass, FalseClass] returns true if token is nil? or empty?; false otherwise.
      def empty?
        InputToken.empty?(@token)
      end

      #--
      # Commands
      #++

      # Returns true or false based on whether or not token is a view stack command.
      #
      # @return [TrueClass, FalseClass] returns true if token is a view stack command; false otherwise.
      def view_stack?
        InputToken.view_stack?(@token)
      end

      # Returns true or false based on whether or not token is a clear stack command.
      #
      # @return [TrueClass, FalseClass] returns true if token is a clear stack command; false otherwise.
      def clear_stack?
        InputToken.clear_stack?(@token)
      end

      # Returns true or false based on whether or not token is a quit command.
      #
      # @return [TrueClass, FalseClass] returns true if token is a quit command; false otherwise.
      def quit?
        InputToken.quit?(@token)
      end

      #--
      # Class methods
      #++

      # Returns a valid list of operators.
      #
      # @return [Hash] Returns the list of operators.
      def self.operators
        if @@operators.nil?
          # Only assign first time, after that, we're good to go.
          InputToken.operators = Configuration.instance.operators
        end
        @@operators
      end

      # Returns a valid list of commands.
      #
      # @return [Hash] Returns the list of commands.
      def self.commands
        if @@commands.nil?
          # Only assign first time, after that, we're good to go.
          InputToken.commands = Configuration.instance.commands
        end
        @@commands
      end

      # Returns true or false based on whether or not token is an operator.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is an operator; false otherwise.
      def self.operator?(token)
        !InputToken.operators[token].nil?
      end

      # Returns true or false based on whether or not token is an operand.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is an operand; false otherwise.
      def self.operand?(token)
        return false if InputToken.operator?(token) || InputToken.command?(token)
        !Float(token).nil? rescue false
      end

      # Returns true or false based on whether or not token is a command.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is a command; false otherwise.
      def self.command?(token)
        !InputToken.commands.key(token).nil?
      end

      # Returns true or false based on whether or not token is an operator, operand or command.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is an operator, operand or command; false otherwise.
      def self.valid?(token)
        return false if token.nil? || InputToken.empty?(token)
        InputToken.operand?(token) || InputToken.operator?(token) || InputToken.command?(token)
      end

      # Returns true or false based on whether or not token is a operator, operand or command.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is not an operator, operand or command; false otherwise.
      def self.invalid?(token)
        !InputToken.valid?(token)
      end

      # Returns true or false based on whether or not token is nil? or empty?.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is nil? or empty?; false otherwise.
      def self.empty?(token)
        token.to_s.empty?
      end

      #--
      # Commands
      #++

      # Returns true or false based on whether or not token is a view stack command.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is a view stack command; false otherwise.
      def self.view_stack?(token)
        return false unless token.respond_to? :downcase
        token = token.downcase
        command_value = commands.key(token)
        command_value.nil? ? false : token == Configuration.instance.view_stack_command.downcase
      end

      # Returns true or false based on whether or not token is a clear stack command.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is a clear stack command; false otherwise.
      def self.clear_stack?(token)
        return false unless token.respond_to? :downcase
        token = token.downcase
        command_value = commands.key(token)
        command_value.nil? ? false : token == Configuration.instance.clear_stack_command.downcase
      end

      # Returns true or false based on whether or not token is a quit command.
      #
      # @param [Object] token The token to interrogate.
      #
      # @return [TrueClass, FalseClass] returns true if token is a quit command; false otherwise.
      def self.quit?(token)
        return false unless token.respond_to? :downcase
        token = token.downcase
        command_value = InputToken.commands.key(token)
        command_value.nil? ? false : token == Configuration.instance.quit_command.downcase
      end

      class << self
        protected

        def commands=(value)
          @@commands = value
        end

        def operators=(value)
          @@operators = value
        end
      end
    end
  end
end
