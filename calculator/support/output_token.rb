require_relative "io_token"
require_relative "../errors/errors"

module RealPage
   module Calculator
   
      class OutputToken < IOToken
         attr_reader :error

         def initialize(token, error = nil)
            super token
            @error = error
         end

         def error?
            !@error.nil?
         end
      end
      
   end
end