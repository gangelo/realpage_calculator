module RealPage
   module Calculator
   
      class IOToken

         public 

         attr_accessor :token

         def initialize(token)
            @token = token || ""
         end

         public

         def self.operators
            {'+' => '+', '-' => '-', '/' => '/', '*' => '*'}
         end

         def operator?
            !InputToken.operators[token].nil?
         end

         def operand?
            return false if operator? || quit?
            Float(token) != nil rescue false
         end

         def quit?
            @token.downcase == "q"
         end

         def valid?
           operand? || operator? || quit?
         end

         def empty?
            @token.empty?
         end
      end
   end
end