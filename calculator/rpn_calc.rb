#!/usr/bin/env ruby

require_relative 'file_interface'
require_relative 'console_interface'
require_relative 'rpn_calculator_service'

if ARGV.count == 0
  RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new).accept
else
  file_name = ARGV[0]
  RealPage::Calculator::FileInterface.new(RealPage::Calculator::RPNCalculatorService.new).accept(file_name)
end
