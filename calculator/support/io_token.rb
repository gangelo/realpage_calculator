module RealPage
   module Calculator
   
      class IOToken
         #attr_accessor :token

         def initialize(token)
            @token = token || ""
         end

         #
         # Instance methods

         def token=(value)
            @token = value
         end

         def token
            IOToken.operand?(@token) ? Float(@token) : @token 
         end

         def operator?
            !InputToken.operator?(@token).nil?
         end

         def operand?
            InputToken.operand?(@token)
         end

         def quit?
            InputToken.quit?(@token)
         end

         def valid?
           InputToken.valid?(@token)
         end

         def invalid?
           !InputToken.valid?(@token)
         end

         def empty?
            InputToken.empty?(@token)
         end

         #
         # Class methods

         def self.operators
            {'+' => '+', '-' => '-', '/' => '/', '*' => '*'}
         end

         def self.operator?(token)
            !InputToken.operators[token].nil?
         end

         def self.operand?(token)
            return false if InputToken.operator?(token) || InputToken.quit?(token)
            Float(token) != nil rescue false
         end

         def self.quit?(token)
            token.to_s.downcase == "q"
         end

         def self.valid?(token)
           InputToken.operand?(token) || InputToken.operator?(token) || InputToken.quit?(token)
         end

         def self.invalid?(token)
           !InputToken.valid?(token)
         end

         def self.empty?(token)
            token.to_s.empty?
         end
      end

   end
end