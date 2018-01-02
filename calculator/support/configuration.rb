require 'yaml'

module RealPage
  module Calculator

    # Singleton. Provides a single interface into configuration values.
    class Configuration

      # Holds an array of valid operators that may be used in computations.
      attr_accessor :operators

      # Holds an array of valid commands that may be used by the interface.
      attr_accessor :commands

      # Holds an array of options specific to the console interface.
      attr_accessor :console_interface_options

      # Initializes an object of this type.
      def initialize
        self.load_config
      end

      # Returns the Configuration instance.
      #
      # @return [Configuration] Returns the single(ton) instance of
      # this Configuraton object.
      def self.instance
        @@instance
      end

      # Retrieves the quit command.
      #
      # @return [String] The value that repesents the quit command.
      def quit_command
        self.commands['quit']
      end

      # Retrieves the clear stack command.
      #
      # @return [String] The value that repesents the clear stack command.
      def clear_stack_command
        self.commands['clear_stack']
      end

      # Retrieves the view stack command.
      #
      # @return [String] The value that repesents the view stack command.
      def view_stack_command
        self.commands['view_stack']
      end

      #--
      # Console-specific
      #++

      def use_readline
        self.console_interface_options['use_readline']
      end

      protected

      # Loads the configuration values from the configuration file.
      def load_config
        configuration = YAML::load_file(File.join(__dir__, '../config/calculator.yml'))
        self.operators = configuration['operators']
        self.commands = configuration['commands']
        self.console_interface_options = configuration['console_interface_options']
      end

      @@instance = Configuration.new
      private_class_method :new
    end

  end
end
