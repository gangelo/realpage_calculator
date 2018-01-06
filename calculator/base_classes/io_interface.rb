require_relative '../errors/must_override_error'
require_relative '../errors/interface_not_ready_error'

module RealPage
  module Calculator
    # Base class for all io interfaces.
    class IOInterface
      protected

      attr_reader :calculator_service
      attr_reader :input_parser

      # Holds the state of this interface - ready, open or closed.
      attr_accessor :state

      public

      def initialize(calculator_service)
        @state = IOInterface.ready_state
        @calculator_service = calculator_service
        @calculator_service.attach_observer(self)
        @input_parser = calculator_service.input_parser
      end

      # Indicates that the interface has been neither opened or closed
      # e.g. awaiting a connection (#accept).
      def self.ready_state
        0b00
      end

      # Indicates that the interface is presently open or has been opened.
      def self.opened_state
        0b10
      end

      # Indicates that the interface is presently closed and incapable of
      # receiving further input.
      def self.closed_state
        0b01
      end

      # Starts the process of receiving input.
      def accept
        raise InterfaceNotReadyError unless ready?
        @state = IOInterface.opened_state
      end

      def ready?
        @state == IOInterface.ready_state
      end

      def open?
        @state == IOInterface.opened_state
      end

      # True ONLY if this interface has been previously opened and closed;
      # returns false otherwise.
      def closed?
        @state == (IOInterface.opened_state | IOInterface.closed_state)
      end

      protected

      # Receives input from the opened stream.
      def receive
        raise MustOverrideError
      end

      # Sends output to the output stream.
      def respond(_output)
        raise MustOverrideError
      end

      # Sends errors to the error stream.
      def respond_error(_output)
        raise MustOverrideError
      end

      # Receives computation or command results from the calculator.
      def receive_calculator_result(_calculator_result)
        raise MustOverrideError
      end

      # Receives errors encountered by the calculator service.
      def receive_calculator_result_error(_calculator_result)
        raise MustOverrideError
      end

      # Override to close the stream. Call this super class to set the proper
      # state to closed?.
      def close
        @state = (IOInterface.opened_state | IOInterface.closed_state)
      end
    end
  end
end
