require 'yaml'

module RealPage
  module Calculator
    # Provides a single(ton) interface into configuration values.
    class Configuration
      attr_reader :operators
      attr_reader :commands
      attr_reader :console_interface_options

      def instance
        self.class.instance
      end

      def initialize
        load_config
      end

      def quit_command
        @commands['quit']
      end

      def clear_stack_command
        @commands['clear_stack']
      end

      def view_stack_command
        @commands['view_stack']
      end

      # Indicates whether or not Readline#readline should be used to obtain
      # input in console interfaces as opposed to $stdin.
      def use_readline?
        @console_interface_options['use_readline']
      end

      protected

      def load_config
        configuration = YAML.load_file(File.join(__dir__, '../config/calculator.yml'))
        @operators = configuration['operators']
        @commands = configuration['commands']
        @console_interface_options = configuration['console_interface_options']
      end

      class << self
        attr_reader :instance
      end

      @instance = Configuration.new
      private_class_method :new
    end
  end
end
