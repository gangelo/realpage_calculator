require_relative '../errors/errors'

module RealPage
   module Calculator
   
      # Provides a container for the result returned from a Calculator computation.
      #
      class CalculatorResult
         public

         attr_reader :result
         attr_reader :error

         def initialize(result, error = Errors::Calculator::NONE)
            raise ArgumentError, "result parameter is nil" if result.nil?
            raise ArgumentError, "error is invalid" if !Errors::Calculator::all_errors.include?(error)

            @result = result
            @error = error
         end

         def error?
            error != Errors::Calculator::NONE
         end
      end

   end
end