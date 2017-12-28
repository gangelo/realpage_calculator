require_relative '../errors/calculator_errors'

module RealPage
   module Calculator
   
      class CalculatorResult
         public

         attr_reader :result
         attr_reader :error

         def initialize(result, error = CalculatorErrors::NONE)
            raise ArgumentError, "result parameter is nil" if result.nil?
            raise ArgumentError, "error is invalid" if !CalculatorErrors::Errors.include?(error)

            @result = result
            @error = error
         end

         def error?
            error != CalculatorErrors::NONE
         end
      end

   end
end