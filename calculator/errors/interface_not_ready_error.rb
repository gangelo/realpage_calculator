module RealPage
   module Calculator

      #
      # Thrown when an attempt to use an interface is unsuccessful because
      # the interface is not in the #ready? status. 
      class InterfaceNotReadyError < StandardError; end
      
   end
end