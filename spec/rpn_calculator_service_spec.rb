require 'spec_helper'

describe "RPNCalculatorService" do
  before(:each) do
    @calculator_service = RealPage::Calculator::RPNCalculatorService.new

    # Change the access modifier on all protected members to public so we can test them.
    RealPage::Calculator::RPNCalculatorService.send(:public, *RealPage::Calculator::RPNCalculatorService.protected_instance_methods)
  end

  subject { @calculator_service }

  context "instance methods" do
    describe "#compute" do
      it { should respond_to(:compute).with(1).arguments }

      it "should produce the expected output given a string of tokens" do
        expect(@calculator_service.compute("5 8 + 13 -").result).to eq(0.0)
        expect(@calculator_service.compute("-3 -2 * 5 +").result).to eq(11.0)
        expect(@calculator_service.compute("5 9 1 - /").result).to eq(0.625)
        expect(@calculator_service.compute("15 7 1 1 + - / 3 * 2 1 1 + + -").result).to eq(5.0)
      end

      it "should produce the expected output given '5 8 + q' one token at a time" do
        expect(@calculator_service.compute("5").result).to eq(5.0)
        expect(@calculator_service.compute("8").result).to eq(8.0)
        expect(@calculator_service.compute("+").result).to eq(13.0)
        expect(@calculator_service.compute("q").result).to eq("")
      end

      it "should produce the expected output given '5 8 + 13 - q' one token at a time" do
        expect(@calculator_service.compute("5").result).to eq(5.0)
        expect(@calculator_service.compute("8").result).to eq(8.0)
        expect(@calculator_service.compute("+").result).to eq(13.0)
        expect(@calculator_service.compute("13").result).to eq(13.0)
        expect(@calculator_service.compute("-").result).to eq(0.0)
        expect(@calculator_service.compute("q").result).to eq("")
      end

      it "should produce the expected output given '-3 -2 * 5 + q' one token at a time" do
        expect(@calculator_service.compute("-3").result).to eq(-3.0)
        expect(@calculator_service.compute("-2").result).to eq(-2.0)
        expect(@calculator_service.compute("*").result).to eq(6.0)
        expect(@calculator_service.compute("5").result).to eq(5.0)
        expect(@calculator_service.compute("+").result).to eq(11.0)
        expect(@calculator_service.compute("q").result).to eq("")
      end

      it "should produce the expected output given '5 9 1 - / q' one token at a time" do
        expect(@calculator_service.compute("5").result).to eq(5.0)
        expect(@calculator_service.compute("9").result).to eq(9.0)
        expect(@calculator_service.compute("1").result).to eq(1.0)
        expect(@calculator_service.compute("-").result).to eq(8.0)
        expect(@calculator_service.compute("/").result).to eq(0.625)
        expect(@calculator_service.compute("q").result).to eq("")
      end

      it "should not add Infinity to the input_stack when dividing by 0" do
        @calculator_service.compute('1 0 /')
        expect(@calculator_service.input_stack).to eq([])
      end

      it "should return the computed value given a string of tokens that ends with 'quit'" do
        expect(@calculator_service.compute("5 8 + 13 - q").result).to eq(0.0)
      end
    end
  end # instance methods

  context "protected instance methods" do
    describe "#notify" do
      it { should respond_to(:notify).with(1).arguments }
      it "should nofity the observer with the calculator result by calling Observer#receive_calculator_result if an observer is attached" do
        expected_result = 1.0
        io_interface = instance_double("RealPage::Calculator::IOInterface", receive_calculator_result: nil)
        expect(io_interface).to receive(:receive_calculator_result).with(an_instance_of(RealPage::Calculator::CalculatorResult)) do |calculator_result|
          expect(calculator_result.result).to eq(expected_result)
          expect(calculator_result.error?).to eq(false)
        end
        @calculator_service.attach_observer io_interface
        @calculator_service.notify(expected_result)
      end
    end

    describe "#notify_error" do
      it { should respond_to(:notify_error).with(2).arguments }
      it "should nofity the observer with the calculator error by calling Observer#receive_calculator_result_error if an observer is attached" do
        expected_result = "invalid_input"
        expected_error = RealPage::Calculator::Errors::Calculator::VALID_INPUT_EXPECTED
        io_interface = instance_double("RealPage::Calculator::IOInterface", receive_calculator_result_error: nil)
        expect(io_interface).to receive(:receive_calculator_result_error).with(an_instance_of(RealPage::Calculator::CalculatorResult)) do |calculator_result_error|
          expect(calculator_result_error.result).to eq(expected_result)
          expect(calculator_result_error.error?).to eq(true)
          expect(calculator_result_error.error).to eq(expected_error)
        end
        @calculator_service.attach_observer io_interface
        @calculator_service.notify_error(expected_result, expected_error)
      end
    end
  end # protected instance methods

end
