require_relative '../support/must_override_error'

module RealPage
   module Calculators
   
      class Service
         protected

         attr_accessor :closed

         public 

         def initialize(calculator)
         	@calculator = calculator
         	@closed = false
         end

         public

         #
         # Starts the process of receiving input. Opening of resources, establishing
         # connections
         def accept
            raise MustOverrideError
         end

         def accept_async
            raise MustOverrideError
         end

         def closed?
            @closed || false
         end

         protected 

         def receive
            raise MustOverrideError
         end

         def respond(input)
            raise MustOverrideError
         end

         def close
            @closed = true
         end
      end
   end
end