require_relative '../errors/calculator_errors'

module RealPage
   module Calculator
   
      class CalculatorResult
         public

         attr_reader :result
         attr_reader :error
         attr_reader :quit

         def initialize(result, error = CalculatorErrors::NONE, quit = false)
            raise ArgumentError, "result parameter is nil" if result.nil?
            raise ArgumentError, "error is invalid" if !CalculatorErrors::Errors.include?(error)

            @result = result
            @error = error
            @quit = quit
         end

         def error?
            error != CalculatorErrors::NONE
         end

         def quit?
            @quit || false
         end
      end

   end
end