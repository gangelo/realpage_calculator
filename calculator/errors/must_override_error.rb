module RealPage
  module Calculator
    # This error should be raised when a method expected to be overidden was called.
    MustOverrideError = Class.new(NoMethodError)
  end
end
