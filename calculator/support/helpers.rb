module RealPage
  module Calculator
    # Namespace that contains all helper methods used in this project.
    module Helpers
      # Module that contains methods for Arrays.
      module Arrays
        def upper_bound(array)
          return -1 unless array.is_a?(Array)
          return -1 if array.nil? || array.empty?
          array.size - 1
        end
      end
      # Module that contains the #blank? method.
      module Blank
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
