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

         it "should raise an error if error_code is not a valid error code" do
            expect { RealPage::Calculator::CalculatorResult.new(nil, -1) }.to raise_exception(ArgumentError)
         end

         it "should NOT raise an error if error_code is a valid error code" do
            RealPage::Calculator::CalculatorErrorCodes::Codes.each do |error_code|
               expect { RealPage::Calculator::CalculatorResult.new("1", error_code) }.to_not raise_exception
            end
         end
      end
   end # initialization

   context "instance methods" do
      describe "#error?" do
         it "should return false if no error_code is provided" do
            calculator_result = RealPage::Calculator::CalculatorResult.new("1")
            expect(calculator_result.error?).to eq(false)
         end

         it "should return false if NONE error_code is provided" do
            calculator_result = RealPage::Calculator::CalculatorResult.new("1", RealPage::Calculator::CalculatorErrorCodes::NONE)
            expect(calculator_result.error?).to eq(false)
         end

          it "should return true if an error_code other than NONE is provided" do
            (1...RealPage::Calculator::CalculatorErrorCodes::Codes.count).each do |error_code|
               calculator_result = RealPage::Calculator::CalculatorResult.new("1", error_code)
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

      describe "#error_code" do
         it "should return the error_code provided to #initialize" do
            calculator_result = RealPage::Calculator::CalculatorResult.new("", RealPage::Calculator::CalculatorErrorCodes::OPERAND_EXPECTED)
            expect(calculator_result.error_code).to eq(RealPage::Calculator::CalculatorErrorCodes::OPERAND_EXPECTED)
         end
      end
   end # attributes

end