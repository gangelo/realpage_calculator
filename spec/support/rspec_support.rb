require_relative '../../calculator/support/configuration'

module RSpecHelpers
  module Configuration
    def quit_command
      RealPage::Calculator::Configuration.instance.quit_command.downcase
    end

    def clear_stack_command
      RealPage::Calculator::Configuration.instance.clear_stack_command.downcase
    end

    def view_stack_command
      RealPage::Calculator::Configuration.instance.view_stack_command.downcase
    end

    def use_readline
      RealPage::Calculator::Configuration.instance.use_readline
    end
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers::Configuration
end
