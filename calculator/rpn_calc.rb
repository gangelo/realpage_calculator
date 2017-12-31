#!/usr/bin/env ruby

require_relative 'console_interface'
require_relative 'rpn_calculator_service'

RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new).accept