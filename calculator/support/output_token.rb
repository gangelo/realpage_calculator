require_relative "io_token"
require_relative "../errors/errors"

module RealPage
   module Calculator
   
      class OutputToken < IOToken

         public

         attr_reader :error

         def error(error)
            # TODO: Verify is RealPage::Calculator::Error type
            @error = error
         end

         def error?
            !@error.nil?
         end

      end
   end
end