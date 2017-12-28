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
   end # initialization

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

      describe "#attach_observer" do
         it "should assign the observer" do
            expect { @calculator_service.attach_observer("x") }.to change { @calculator_service.interface_observer }.from(nil).to("x") 
         end
      end
   end # instance methods

   context "protected instance methods" do
      describe "#notify_observer_result" do
         it { should respond_to(:notify_observer_result).with(1).arguments }
         it "should nofity the observer with a calculator result by calling Observer#receive_calculator_result if an observer is attached" do
            expected_result = 1.0
            io_interface = instance_double("RealPage::Calculator::IOInterface", receive_calculator_result: nil)
            expect(io_interface).to receive(:receive_calculator_result).with(an_instance_of(RealPage::Calculator::CalculatorResult)) do |calculator_result|
               expect(calculator_result.result).to eq(expected_result)
               expect(calculator_result.error?).to eq(false)
            end
            @calculator_service.attach_observer io_interface
            @calculator_service.notify_observer_result(expected_result)
         end
      end

      describe "#notify_observer_result_error" do
         it { should respond_to(:notify_observer_result_error).with(2).arguments }
         it "should nofity the observer with a calculator error by calling Observer#receive_calculator_result_error if an observer is attached" do
            expected_result = "invalid_input"
            expected_error = RealPage::Calculator::CalculatorErrors::VALID_INPUT_EXPECTED
            io_interface = instance_double("RealPage::Calculator::IOInterface", receive_calculator_result_error: nil)
            expect(io_interface).to receive(:receive_calculator_result_error).with(an_instance_of(RealPage::Calculator::CalculatorResult)) do |calculator_result_error|
               expect(calculator_result_error.result).to eq(expected_result)
               expect(calculator_result_error.error?).to eq(true)
               expect(calculator_result_error.error).to eq(expected_error)
            end
            @calculator_service.attach_observer io_interface
            @calculator_service.notify_observer_result_error(expected_result, expected_error)
         end
      end
   end # protected instance methods

end