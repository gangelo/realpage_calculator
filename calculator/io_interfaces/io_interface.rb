require_relative '../errors/must_override_error'
require_relative '../errors/interface_not_ready_error'

module RealPage
   module Calculator
   
      class IOInterface
         protected

         attr_reader :calculator
         attr_accessor :status

         public 

         def initialize(calculator)   
            @status = IOInterface.ready_status
            @calculator = calculator
            @calculator.attach_observer(self)
         end

         #
         # Class attributes

         #
         # The interface has been neither opened or closed e.g. awaiting a connection (#accept).
         def self.ready_status
            0b00
         end

         #
         # The interface is presently open or has been opened.
         def self.opened_status
            0b10
         end

         #
         # The interface is presently closed.
         def self.closed_status
            0b01
         end

         public

         #
         # Starts the process of receiving input. Accept connections, 
         # open files, initial STDIN prompts, etc.
         def accept
            if ready?
               @status = IOInterface.opened_status
            else
               raise InterfaceNotReadyError
            end
         end

         def accept_async
            raise MustOverrideError
         end

         #
         # Returns true if this interface is not open or closed (waiting #accept); false otherwise.
         def ready?
            @status == IOInterface.ready_status
         end

         #
         # Returns true if this interface is open and accepting input, typical by calling #accept; returns false otherwise.
         def open?
            @status == IOInterface.opened_status
         end

         #
         # Returns true ONLY if this interface has been opened and closed; returns false otherwise.
         def closed?
            @status == (IOInterface.opened_status | IOInterface.closed_status)
         end

         protected 

         #
         # Receives input from the stream previously accepted.
         def receive
            raise MustOverrideError
         end

         #
         # Sends processed output to the stream previously accepted.
         def respond(output)
            raise MustOverrideError
         end

         #
         # Should receive the calculator result from the calculator via 
         # notification as a result of attaching to the calculator as an observer.
         # When calculator input is received, it should be subsequently
         # passed to the interface output stream.
         def receive_calculator_result(calculator_result)
            raise MustOverrideError
         end

         #
         # Should receive the calculator result error from the calculator via
         # notification as a result of attaching to the calculator as an observer.
         # When calculator input error is received, it should be subsequently
         # passed to the interface error output stream.
         def receive_calculator_result_error(calculator_result)
            raise MustOverrideError
         end

         #
         # Terminates this interface. Close connections, files,
         # stop receiving input from STDIN, etc.
         def close
            @status |= IOInterface.closed_status
         end
      end

   end
end