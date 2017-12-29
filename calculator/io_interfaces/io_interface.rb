require_relative '../errors/must_override_error'
require_relative '../errors/interface_not_ready_error'

module RealPage
   module Calculator
   
      # Provides a base for interfaces. Classes inheriting IOInterface are responsible
      # for overriding and implementing several methods in order to provide functionality specific 
      # to the interface in question.
      class IOInterface
         protected

         # Holds a reference to the CalculatorService derived class object that this
         # interface will use to compute input and receive output from in order to
         # send back to the output stream.
         attr_reader :calculator_service

         # Holds the state of this interface - ready, open or closed.
         attr_accessor :state

         public 

         # Initializes an object of this type.
         #
         # @param [CalculatorService] calculator_service A CalculatorService or derived class object
         # that this interface will use to compute input and receive output from in order to
         # send back to the output stream.
         def initialize(calculator_service)   
            @state = IOInterface.ready_state
            @calculator_service = calculator_service
            @calculator_service.attach_observer(self)
         end

         #--
         # Class attributes
         #++

         # The ready_state state value. This state indicates that the interface has been neither 
         # opened or closed e.g. awaiting a connection (#accept).
         #
         # @return [Fixnum] Returns the binary value that represents the ready_state.
         def self.ready_state
            0b00
         end

         # The opened_state state value. This state indicates that the iinterface is 
         # presently open or has been opened.
         #
         # @return [Fixnum] Returns the binary value that represents the opened_state.
         def self.opened_state
            0b10
         end

         # The closed_state state value. This state indicates that the iinterface is 
         # presently closed and incapable of receiving further input.
         #
         # @return [Fixnum] Returns the binary value that represents the closed_state.
         def self.closed_state
            0b01
         end

         public

         # Starts the process of receiving input (e.g. accepts connect requests, 
         # open files, initial STDIN prompts, etc.) and sets the interface state to 
         # #opened_state. An InterfaceNotReadyError is raised if this interface is not 
         # in a #ready? state.
         def accept
            if self.ready?
               @state = IOInterface.opened_state
            else
               raise InterfaceNotReadyError
            end
         end

         def accept_async
            raise MustOverrideError
         end

         # Returns the ready state of this interface.
         #
         # @return [TrueClass, FalseClass] Returns true if this interface is in the ready state 
         # (i.e. not open or closed); false otherwise.
         def ready?
            @state == IOInterface.ready_state
         end

         # Returns the open state of this interface.
         #
         # @return [TrueClass, FalseClass] Returns true if this interface is open and accepting input, 
         # typical by calling #accept; returns false otherwise.
         def open?
            @state == IOInterface.opened_state
         end

         # Returns the closed state of this interface.
         #
         # @return [TrueClass, FalseClass] Returns true ONLY if this interface has been opened 
         # and closed; returns false otherwise.
         def closed?
            # We're not considered
            @state == (IOInterface.opened_state | IOInterface.closed_state)
         end

         protected 

         # Receives input from the opened stream. This method needs to be overridden.
         #
         # @return [String] This method, when overridden, should return
         # input from open stream.
         def receive
            raise MustOverrideError
         end

         # Sends processed output to the output stream. This method needs to be overridden.
         #
         # @param [Object] output This method, when overridden, should send the output passed
         # to the output stream.
         def respond(output)
            raise MustOverrideError
         end

         # Sends an error to the appropriate error output stream. This method needs to be overridden.
         #
         # @param [Object] output This method, when overridden, should send the output passed
         # to the appropriate error output stream.
         def respond_error(output)
            raise MustOverrideError
         end

         # Receives a CalculatorResult from a CalculatorService or derived class object via 
         # notification as a result of attaching this interface to @calculator_service as an observer.
         # When @calculator_service input is received, it should be subsequently passed to
         # the interface output stream.
         #
         # @param [CalculatorResult] calculator_result A CalculatorResult object that contains the CalculatorService 
         # result to send to the output stream.
         def receive_calculator_result(calculator_result)
            raise MustOverrideError
         end

         # Receives a CalculatorResult from a CalculatorService or derived class object via 
         # notification as a result of attaching this interface to @calculator_service as an observer.
         # When a @calculator_service error is encountered, it should be subsequently passed to 
         # the interface error output stream.
         #
         # @param [CalculatorResult] calculator_result A CalculatorResult object that contains the CalculatorService 
         # error to send to the error output stream.
         def receive_calculator_result_error(calculator_result)
            raise MustOverrideError
         end

         # Closes this interface (e.g. Close connections, files, etc.) and should prohibit receiving 
         # input from the input stream. Calling this method sets the #closed_state of this interface.
         def close
            @state = (IOInterface.opened_state | IOInterface.closed_state)
         end
      end

   end
end