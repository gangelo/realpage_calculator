module RealPage
  module Calculator
    # Namespace that contains all helper methods used in this project.
    module Helpers
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
