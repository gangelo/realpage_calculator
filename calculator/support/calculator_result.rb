require_relative '../errors/messages'

module RealPage
  module Calculator
    # Provides a container for the result returned from a calculator service
    # computation.
    class CalculatorResult
      attr_reader :result

      alias token result

      # Holds additional parameters in the for of a Hash, if any, passed to the
      # initializer. Typically, this will hold Messages::Calculator::Errors,
      # Messages::Calculator::Warnings, etc. 
      # e.g. { message: Messages::Calculator::Errors.the_message }, 
      # { message: Messages::Calculator::Warnings.the_message }, where
      # the_message = the message specific to the Messages::Calculator module.
      attr_reader :params

      # params should be a Hash of values.
      def initialize(result, params = nil)
        raise ArgumentError, 'result parameter is nil' if result.nil?

        @result = result
        @params = params

        validate_message
      end

      def message
        return {} unless message?
        @params[:message]
      end

      def message?
        return false if @params.nil?
        return false unless @params.is_a?(Hash)
        @params.has_key?(:message)
      end

      def error?
        return false unless message?
        message[:type] == :error && message[:key] != :none
      end

      def warning?
        return false unless message?
        message[:type] == :warning && message[:key] != :none
      end

      private
        def validate_message
          return unless message?
          raise ArgumentError , "parameter '#{message}' does not specify the message type (i.e. :error, :warning, etc.)" unless message.has_key?(:type)
          raise ArgumentError, "message: '#{message}' is not a valid message" unless CalculatorErrors.all_errors.include?(message) || CalculatorWarnings.all_warnings.include?(message)
        end
    end
  end
end
