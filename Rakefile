
desc 'Use the RPNCalculatorService using the ConsoleInterface'
task :console do
  require_relative './calculator/rpn_calculator_service'
  require_relative './calculator/console_interface'

  RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new).accept
end
