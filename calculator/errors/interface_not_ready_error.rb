module RealPage
  module Calculator

    # Thrown when an attempt to use an IOInterface object or derived class object is unsuccessful because
    # the interfaces' status was not #ready?.
    class InterfaceNotReadyError < StandardError; end

  end
end
