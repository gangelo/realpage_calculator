
desc "Use the RPNCalculatorService using the ConsoleInterface"
task :console do
   require_relative "calculator/calculators"

   RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new).run
end