require 'yaml'

module RealPage
   module Calculator

      class Configuration

         attr_accessor :loaded
         attr_accessor :operators
         attr_accessor :commands

         def initialize
            self.load_config
         end

         def self.instance
            @@instance
         end

         def quit_command
            self.commands['quit']
         end

         def clear_stack_command
            self.commands['clear_stack']
         end

         def view_stack_command
            self.commands['view_stack']
         end

         protected

         def load_config
            configuration = YAML::load_file(File.join(__dir__, '../config/calculator_service_config.yml'))
            self.operators = configuration['operators']
            self.commands = configuration['commands']
            self.loaded = true
         end

         @@instance = Configuration.new
         private_class_method :new 
      end

   end
end