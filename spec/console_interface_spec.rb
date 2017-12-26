require 'spec_helper'

describe "ConsoleInterface" do 
   before(:each) do
      @console_interface = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::ConsoleInterface.send(:public, *RealPage::Calculator::ConsoleInterface.protected_instance_methods)
      # Suppress the prompt so that we don't muddy out test output
      allow_any_instance_of(RealPage::Calculator::ConsoleInterface).to receive(:display_prompt).and_return(nil)
   end

   subject { @console_interface }

   context "instance methods" do
      describe "#accept" do
         it { should respond_to(:accept).with(0).arguments }
         it "should change the interface #status from #ready? to #open?" do
            allow(@console_interface).to receive(:receive).and_return(quit_command)
            ready_status = RealPage::Calculator::ConsoleInterface.ready_status
            open_status = RealPage::Calculator::ConsoleInterface.opened_status
            expect { @console_interface.accept }.to change { @console_interface.status }.from(ready_status).to(open_status)
         end
         it "should raise an InterfaceNotReadyError if the interface is not #ready?" do
            allow($stdin).to receive(:gets).and_return(quit_command)
            expect { @console_interface.accept }.to_not raise_error
            expect { @console_interface.accept }.to raise_error(RealPage::Calculator::InterfaceNotReadyError) 
         end
      end

      describe "#receive" do
         it { should respond_to(:receive).with(0).arguments }
         it "should receive input from $stdin and return it" do
            # Suppress output to the console so that we don't muddy our test output
            expect(@console_interface).to receive(:respond).and_return(nil)

            input = "1 1 + #{quit_command}\n"
            expect(@console_interface).to receive(:receive).and_return(input)
            allow($stdin).to receive(:gets).and_return(input)
            @console_interface.accept
         end
      end

      describe "#receive_calculator_result" do
         it "should receive output from the calendar after a compute operation"
         it "should pass output from the calendar to the output stream after a compute operation"
         it "should close the interface if the quit command is found"
      end

      describe "#receive_calculator_result_error" do
          it "should do something..."
      end

      describe "#display_prompt" do
          it "should do something..."
      end
   end # instance methods

end