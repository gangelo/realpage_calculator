module RealPage
   module Calculator
   
      class InputToken

         public 

         attr_accessor :token

         def initialize(token)
            @token = token
         end

         public

         def self.operators
            {'+' => '+', '-' => '-', '/' => '/', '*' => '*'}
         end

         def operator?
            !InputToken.operators[token].nil?
         end

         def operand?
            return false if operator?
            Float(token) != nil rescue false
         end

         def valid?
           operand? || operator?
         end
      end
   end
end