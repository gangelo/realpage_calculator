
desc "Use the RPNCalculatorService using the ConsoleInterface"
task :console do
   require_relative "calculator/io_interfaces/console_interface"
   require_relative "calculator/calculator_services/rpn_calculator_service"

   calculator = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
   calculator.accept
end