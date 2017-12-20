
module RealPage
   module Calculators
      class RPNInputParser

         def tokenize(input)
         	return [] if nil_or_empty?(input)
         	parse(input)
         end

         protected

         #
         # This member simply checks to make sure the input is not nil? or empty?.
         def nil_or_empty?(input)
         	input.nil? || input.strip.empty?
         end

         def parse(input)
         	input = input.split
         end
      end
   end
end