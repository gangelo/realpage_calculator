module RealPage
  module Calculator
    # Namespace that contains all helper methods used in this project.
    module Helpers

      # Module that contains methods for Arrays.
      module Arrays
        # Returns the upper bound of an array.
        #
        # @param [Array] array The array whose upper bound is to be returned.
        #
        # @return [Fixnum] The upper bound of the array.
        def upper_bound(array)
          return -1 unless array.is_a?(Array)
          return -1 if array.nil? || array.empty?
          array.size - 1
        end
      end

      # Module that contains the #blank? method.
      module Blank
        # Method that checks an object for nil or empty.
        #
        # @param [Object] object to interrogate.
        #
        # @return [TrueClass, FalseClass] Returns true if the object is
        # nil? or empty?; false otherwise.
        def blank?(object)
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
end
