require_relative '../support/configuration'

module RealPage
   module Calculator
   
      class InputToken
         protected

         @@operators = nil
         @@commands = nil
         
         public

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
            if @@operators.nil?
               @@operators = Configuration.instance.operators
            end
            @@operators
         end

         def self.commands
             if @@commands.nil?
               @@commands = Configuration.instance.commands
            end
            @@commands
         end

         def self.operator?(token)
            !InputToken.operators[token].nil?
         end

         def self.operand?(token)
            return false if InputToken.operator?(token) || InputToken.command?(token)
            Float(token) != nil rescue false
         end

         def self.command?(token)
            InputToken.commands.key(token)
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
            InputToken.commands.key(token).downcase == "view_stack"
         end

         def self.clear_stack?(token)
            InputToken.commands.key(token).downcase == "clear_stack"
         end

         def self.quit?(token)
            token.to_s.downcase == "q"
         end
      end

   end
end