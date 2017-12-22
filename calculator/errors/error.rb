module RealPage
   module Calculator

      #
      # An operand was expected, but 'x' was encountered instead.
      class Error
         attr_accessor :token

         def initialize(token = nil)
            @token = token
         end

         def message
         end
      end

   end
end