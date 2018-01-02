module RealPage
  module Calculator
    module Helpers
      # Method that checks an object for nil or empty.
      #
      # @param [Object] object to interrogate.
      #
      # @return [TrueClass, FalseClass] Returns true if the object is
      # nil? or empty?; false otherwise.
      def self.blank?(object)
        return true if object.nil?
        case
        when object.respond_to?(:to_s)
          return object.to_s.strip.empty?
        when object.respond_to?(:empty?)
          return object.empty?
        else
          return false
        end
      end
    end
  end
end
