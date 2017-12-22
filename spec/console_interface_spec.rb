require 'spec_helper'

describe "ConsoleInterface" do 

   context "instance methods" do

      describe "#accept" do
         before do
            @rpn_calculator = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
         end
         it "should call #receive to start receiving input" do
            expect(@rpn_calculator).to receive(:receive).once
            @rpn_calculator.accept 
         end
      end

      describe "#receive" do
         before(:each) do
            @rpn_calculator = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
         end
         it "should call #respond to send calculator results to the output stream" do
            allow($stdin).to receive(:gets).and_return("q")
            expect(@rpn_calculator).to receive(:respond)
            @rpn_calculator.accept 
         end
      end

   end # instance methods
end