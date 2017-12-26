require_relative '../../calculator/support/configuration'

module RSpecHelpers
   module Configuration
      def quit_command
         RealPage::Calculator::Configuration.instance.quit_command.downcase
      end
   end
end

RSpec.configure do |config|
   config.include RSpecHelpers::Configuration
end