


Interface 
Responsible for capturing input from the consumer and sending this input to the Calculator for processing, as well as receiving output from the Calculator and sending this output back to the consumer.
Responsible for receiving errors from the Calculator, translating these errors into a format applicable to the interface, and then sending this error back to the consumer.
Responsible for detecting input terminating character sequence "q or end of input indicator (EOF / Ctrl+D)," and taking the appropriate action to terminate the session.


Calculator
Responsible for processing the input received from the Interface and sending the appropriate response back to the Interface.


RealPage::Calculators::RPNCalculator.new RealPage::Calculators::ConsoleInterface.new



RealPage::Calculators::ConsoleInterface.new(RealPage::Calculators::RPNCalculator.new)