module RealPage
   module Calculator
   
      class IOToken
         attr_accessor :token

         def initialize(token)
            @token = token || ""
         end

         def self.operators
            {'+' => '+', '-' => '-', '/' => '/', '*' => '*'}
         end

         def operator?
            !InputToken.operators[@token].nil?
         end

         def operand?
            return false if operator? || quit?
            Float(@token) != nil rescue false
         end

         def quit?
            @token.to_s.downcase == "q"
         end

         def valid?
           operand? || operator? || quit?
         end

         def empty?
            @token.to_s.empty?
         end
      end
      
   end
end