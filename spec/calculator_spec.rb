require 'spec_helper'

describe "Calculator" do
   
   before do
      @calculator = RealPage::Calculators::Calculator.new
   end

   subject { @calculator }

   context "initialization" do
      describe "#initilize" do
         it "should accept a valid input parser" do
            expect { RealPage::Calculators::Calculator.new(RealPage::Calculators::RPNInputParser.new) }.not_to raise_error 
         end

         it "should accept nil and use the default input parser" do
            expect { RealPage::Calculators::Calculator.new }.not_to raise_error 
            input_parser = RealPage::Calculators::Calculator.new
            expect(input_parser.instance_variable_get(:@input_parser)).to_not be(nil)
         end

         it "should set instance variable @input_parser" do
            input_parser = RealPage::Calculators::Calculator.new(RealPage::Calculators::RPNInputParser.new)
            expect(input_parser.instance_variable_get(:@input_parser)).to_not be(nil)
         end

         it "should raise ArgumentError if input_parser is invalid" do
            expect { RealPage::Calculators::Calculator.new("bad_parser") }.to raise_error(ArgumentError, "input_parser does not implement method #tokenize") 
         end
      end
   end

   context "methods" do

      describe "#calculate" do
         it { should respond_to(:calculate).with(1).argument }
         it "should raise MustOverrideError" do
            expect { @calculator.calculate("blah blah") }.to raise_error(MustOverrideError) 
         end
      end

   end

end