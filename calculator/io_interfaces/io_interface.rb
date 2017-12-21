require_relative '../errors/must_override_error'

module RealPage
   module Calculator
   
      class IOInterface
         protected

         attr_accessor :closed

         public 

         def initialize(calculator)
            @closed = true
            @calculator = calculator
         end

         public

         #
         # Starts the process of receiving input. Accept connections, 
         # open files, initial STDIN prompts, etc.
         def accept
            raise MustOverrideError
         end

         def accept_async
            raise MustOverrideError
         end

         #
         # Returns true if this service is closed; false otherwise.
         def closed?
            @closed
         end

         #
         # Returns true if this service is open and accepting input; false otherwise.
         def open?
            !@closed
         end

         protected 

         #
         # Receive input from the resource previously accepted.
         # When input is received, it should be processed subsequently.
         def receive
            raise MustOverrideError
         end

         #
         # Sends processed input back to the resource previously accepted.
         def respond(output)
            raise MustOverrideError
         end

         #
         # Terminates this service. Close connections, files,
         # stop receiving input from STDIN, etc.
         def close
            @closed = true
         end
      end
   end
end