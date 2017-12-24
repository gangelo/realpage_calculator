require 'spec_helper'

describe "CalculatorService" do
   before do
      @calculator_service = RealPage::Calculator::CalculatorService.new RealPage::Calculator::RPNInputParser.new

      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::CalculatorService.send(:public, *RealPage::Calculator::CalculatorService.protected_instance_methods)   
   end

   subject { @calculator_service }

   context "initialization" do
      describe "#initilize" do
         it "should accept a valid input parser" do
            expect { RealPage::Calculator::CalculatorService.new(RealPage::Calculator::RPNInputParser.new) }.not_to raise_error 
         end

         it "should set instance variable @input_parser" do
            input_parser = RealPage::Calculator::CalculatorService.new(RealPage::Calculator::RPNInputParser.new)
            expect(input_parser.instance_variable_get(:@input_parser)).to_not be(nil)
         end

         it "should raise ArgumentError if input_parser is nil? or empty?" do
            expect { RealPage::Calculator::CalculatorService.new(nil) }.to raise_error(ArgumentError, "input_parser is nil or empty") 
            expect { RealPage::Calculator::CalculatorService.new("") }.to raise_error(ArgumentError, "input_parser is nil or empty") 
         end
      end
   end

   context "instance methods" do
      describe "#compute" do
         it { should respond_to(:compute).with(1).argument }
         it "should raise MustOverrideError" do
            expect { @calculator_service.compute("blah blah") }.to raise_error(RealPage::Calculator::MustOverrideError) 
         end
      end

      describe "#clear" do
         it { should respond_to(:clear).with(0).argument }
         it "should clear the input stack when called" do
            @calculator_service.input_stack = [1.0, 2.0, 3.0] 
            expect { @calculator_service.clear }.to change { @calculator_service.input_stack }.from([1.0, 2.0, 3.0]).to([]) 
         end
      end
   end

end