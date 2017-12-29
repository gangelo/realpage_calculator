
desc "Use the RPNCalculatorService using the ConsoleInterface"
task :console do
   require_relative "calculator/calculators"

   calculator = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
   calculator.accept
end