module RealPage
   module Calculator
   
      class InputToken
         def initialize(token = nil)
            @token = token
         end

         #
         # Instance methods

         def token=(value)
            @token = value
         end

         def token
            InputToken.operand?(@token) ? Float(@token) : @token 
         end

         def operator?
            !InputToken.operator?(@token).nil?
         end

         def operand?
            InputToken.operand?(@token)
         end

         def command?
            InputToken.command?(@token)
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
         # Commands

         def view_stack?
            InputToken.view_stack?(@token)
         end

         def clear_stack?
            InputToken.clear_stack?(@token)
         end

         def quit?
            InputToken.quit?(@token)
         end

         #
         # Class methods

         def self.operators
            {'+' => '+', '-' => '-', '/' => '/', '*' => '*'}
         end

         #
         # Commands:
         #
         # v - view the input stack
         # c - clear the input stack
         # q - quit
         def self.commands
            ['v', 'c', 'q']
         end

         def self.operator?(token)
            !InputToken.operators[token].nil?
         end

         def self.operand?(token)
            return false if InputToken.operator?(token) || InputToken.command?(token)
            Float(token) != nil rescue false
         end

          def self.command?(token)
            InputToken.commands.include?(token)
         end

         def self.valid?(token)
            return false if token.nil? || InputToken.empty?(token)
            InputToken.operand?(token) || InputToken.operator?(token) || InputToken.command?(token)
         end

         def self.invalid?(token)
           !InputToken.valid?(token)
         end

         def self.empty?(token)
            token.to_s.empty?
         end

         #
         # Commands

         def self.view_stack?(token)
            token.to_s.downcase == "v"
         end

         def self.clear_stack?(token)
            token.to_s.downcase == "c"
         end

         def self.quit?(token)
            token.to_s.downcase == "q"
         end
      end

   end
end