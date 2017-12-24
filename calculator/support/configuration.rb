require 'yaml'

module RealPage
   module Calculator

      class Configuration

         attr_accessor :loaded
         attr_accessor :operators
         attr_accessor :commands

         def initialize
            load_config
         end

         def self.instance
            @@instance
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