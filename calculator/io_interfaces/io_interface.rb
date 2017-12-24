require_relative '../errors/must_override_error'

module RealPage
   module Calculator
   
      class IOInterface
         protected

         attr_reader :calculator
         attr_accessor :status

         public 

         def initialize(calculator)
            @status = @@ready_status
            @calculator = calculator
         end

         class << self
            attr_reader :ready_status
            attr_reader :opened_status
            attr_reader :closed_status

            @@ready_status  = 0b00 # The interface has been neither opened or closed e.g. awaiting a connection (#accept).
            @@opened_status = 0b10 # The interface is presently open or has been opened.
            @@closed_status = 0b01 # The interface is presently closed.
         end

         public

         #
         # Starts the process of receiving input. Accept connections, 
         # open files, initial STDIN prompts, etc.
         def accept
            if ready?
               @status = @@opened_status
               return true
            else
               return false
            end
         end

         def accept_async
            raise MustOverrideError
         end

         #
         # Returns true if this interface is not open or closed (waiting #accept); false otherwise.
         def ready?
            @status == @@ready_status
         end

         #
         # Returns true if this interface is open and accepting input, typical by calling #accept; returns false otherwise.
         def open?
            @status == @@opened_status
         end

         #
         # Returns true ONLY if this interface has been opened and closed; returns false otherwise.
         def closed?
            @status == (@@opened_status | @@closed_status)
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
         # Terminates this interface. Close connections, files,
         # stop receiving input from STDIN, etc.
         def close
            @status |= @@closed_status
         end
      end

   end
end