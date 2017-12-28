module RealPage
   module Calculator

      # This error should be raised when a method expected to be overidden was called.
      class MustOverrideError < NoMethodError; end
      
   end
end