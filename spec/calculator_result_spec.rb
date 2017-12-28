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
            RealPage::Calculator::CalculatorErrors::Errors.each do |error|
               expect { RealPage::Calculator::CalculatorResult.new("1", error) }.to_not raise_exception
            end
         end
      end
   end # initialization

   context "instance methods" do
      describe "#error?" do
         it "should return false if no error is provided" do
            calculator_result = RealPage::Calculator::CalculatorResult.new("1")
            expect(calculator_result.error?).to eq(false)
         end

         it "should return false if NONE error is provided" do
            calculator_result = RealPage::Calculator::CalculatorResult.new("1", RealPage::Calculator::CalculatorErrors::NONE)
            expect(calculator_result.error?).to eq(false)
         end

         it "should return true if an error other than NONE is provided" do
            RealPage::Calculator::CalculatorErrors::Errors.each do |error|
               next if error[:key] == :none
               calculator_result = RealPage::Calculator::CalculatorResult.new("1", error)
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
            calculator_result = RealPage::Calculator::CalculatorResult.new("", RealPage::Calculator::CalculatorErrors::OPERAND_EXPECTED)
            expect(calculator_result.error).to eq(RealPage::Calculator::CalculatorErrors::OPERAND_EXPECTED)
         end
      end
   end # attributes

end