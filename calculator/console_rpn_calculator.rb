#!/usr/bin/env ruby

require_relative 'console_interface'
require_relative 'rpn_calculator_service'

module RealPage
   module Calculator

      class ConsoleRPNCalculator 
         def self.run
            ConsoleInterface.new(RPNCalculatorService.new).accept
         end
      end

   end
end

RealPage::Calculator::ConsoleRPNCalculator.run