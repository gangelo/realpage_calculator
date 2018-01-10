require 'spec_helper'

describe "CalculatorResult" do

  context "initialization" do
    describe "#initialize" do
      it "should raise an error if result is nil?" do
        expect { RealPage::Calculator::CalculatorResult.new(nil) }.to raise_exception(ArgumentError)
      end

      it "should NOT raise an error if result is NOT nil?" do
        expect { RealPage::Calculator::CalculatorResult.new("") }.to_not raise_exception
      end

      it "should raise an error if error is not a valid error code" do
        expect { RealPage::Calculator::CalculatorResult.new(nil, -1) }.to raise_exception(ArgumentError)
      end

      it "should NOT raise an error if error is a valid error code" do
        CalculatorErrors.all_errors.each do |error|
          expect { RealPage::Calculator::CalculatorResult.new("1", { message: error }) }.to_not raise_exception
        end
      end
    end
  end # initialization

  context "instance methods" do
    describe '#message' do
      it 'should return the error if an error is available' do
        message = CalculatorErrors.none
        calculator_result = RealPage::Calculator::CalculatorResult.new('1.0', { message: message })
        expect(calculator_result.message).to eq(message)
      end
      it 'should return the warning if a warning is available' do
        message = CalculatorWarnings.none
        calculator_result = RealPage::Calculator::CalculatorResult.new('1.0', { message: message })
        expect(calculator_result.message).to eq(message)
      end
      it 'should return an empty Hash if a message is not available' do
        calculator_result = RealPage::Calculator::CalculatorResult.new('2.0')
        expect(calculator_result.message).to eq({})
      end
    end

    describe '#message?' do
      it 'should return true if a message is available' do
        message = CalculatorErrors.operand_expected
        calculator_result = RealPage::Calculator::CalculatorResult.new('-1.0', { message: message })
        expect(calculator_result.message?).to eq(true)
      end
      it 'should return false if a message is not available' do
        calculator_result = RealPage::Calculator::CalculatorResult.new('-1.0')
        expect(calculator_result.message?).to eq(false)

        calculator_result = RealPage::Calculator::CalculatorResult.new('0', { dummy: :hello})
        expect(calculator_result.message?).to eq(false)
      end
    end

    describe '#warning?' do
      it "should return false if no warning is provided" do
        calculator_result = RealPage::Calculator::CalculatorResult.new("1")
        expect(calculator_result.warning?).to eq(false)
      end

      it "should return false if #none warning is provided" do
        calculator_result = RealPage::Calculator::CalculatorResult.new("1", { message: CalculatorWarnings.none })
        expect(calculator_result.warning?).to eq(false)
      end

      it "should return true if a warning other than #none is provided" do
        CalculatorWarnings.all_warnings.each do |warning|
          next if warning[:key] == :none
          calculator_result = RealPage::Calculator::CalculatorResult.new("1", { message: warning })
          expect(calculator_result.warning?).to eq(true)
        end
      end
    end

    describe "#error?" do
      it "should return false if no error is provided" do
        calculator_result = RealPage::Calculator::CalculatorResult.new("1")
        expect(calculator_result.error?).to eq(false)
      end

      it "should return false if #none error is provided" do
        calculator_result = RealPage::Calculator::CalculatorResult.new("1", { message: CalculatorErrors.none })
        expect(calculator_result.error?).to eq(false)
      end

      it "should return true if an error other than #none is provided" do
        CalculatorErrors.all_errors.each do |error|
          next if error[:key] == :none
          calculator_result = RealPage::Calculator::CalculatorResult.new("1", { message: error })
          expect(calculator_result.error?).to eq(true)
        end
      end
    end
  end # instance methods

  context "attributes" do
    describe "#result" do
      it "should return the result provided to #initialize" do
        calculator_result = RealPage::Calculator::CalculatorResult.new("1")
        expect(calculator_result.result).to eq("1")
      end
    end

    describe "#error" do
      it "should return the error provided to #initialize" do
        calculator_result = RealPage::Calculator::CalculatorResult.new("", { message: CalculatorErrors.operand_expected })
        expect(calculator_result.message).to eq(CalculatorErrors.operand_expected)
      end
    end
  end # attributes

end
