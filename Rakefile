
desc 'Use the RPNCalculatorService using the ConsoleInterface'
task :console do
  require_relative './calculator/rpn_calculator_service'
  require_relative './calculator/console_interface'

  puts('Using RPNCalculatorService with ConsoleInterface...')
  RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new).accept
end

desc 'Use the RPNCalculatorService using the FileInterface'
task :file do
  require_relative './calculator/rpn_calculator_service'
  require_relative './calculator/file_interface'

  input_file = 'spec/files/rpn_input_file.txt'
  puts("Using RPNCalculatorService with FileInterface. Input file: #{input_file}...")
  RealPage::Calculator::FileInterface.new(RealPage::Calculator::RPNCalculatorService.new).accept(input_file)
end