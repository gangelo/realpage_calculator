module RealPage
   module Calculator
      #
      # An operand was expected, but 'x' was encountered instead.
      class Error
         
         public

         attr_reader :token

         def initialize(token)
            @token = token
         end

         def message
         end

      end
   end
end