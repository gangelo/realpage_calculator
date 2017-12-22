require_relative '../errors/calculator_error_codes'

module RealPage
   module Calculator
   
      class CalculatorResult
         public

         attr_reader :result
         attr_reader :error_code
         attr_reader :quit

         def initialize(result, error_code = CalculatorErrorCodes::NONE, quit = false)
            raise ArgumentError, "result parameter is nil" if result.nil?
            raise ArgumentError, "error_code #{error_code} is invalid" if !CalculatorErrorCodes::Codes.include?(error_code)

            @result = result
            @error_code = error_code
            @quit = quit
         end

         def error?
            error_code != CalculatorErrorCodes::NONE
         end

         def quit?
            @quit || false
         end
      end

   end
end