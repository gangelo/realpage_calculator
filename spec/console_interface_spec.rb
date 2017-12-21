require 'spec_helper'

describe "ConsoleInterface" do 
   before do
      @interface = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
   end

   subject { @interface }

   context "methods" do

=begin
      describe "#tokenize" do
         it { should respond_to(:tokenize).with(1).arguments }

         it "should return [] if input is nil?" do
            expect(@input_parser.tokenize(nil)).to eq([])
         end

         it "should return [] if input is empty?" do
            expect(@input_parser.tokenize("")).to eq([])
         end

         it "should return [] if input is spaces" do
            expect(@input_parser.tokenize("")).to eq([])
         end

         it "should convert string input to a token array" do
            expect(@input_parser.tokenize("1 1 +").to_token_array).to eq(["1", "1", "+"]) 
            expect(@input_parser.tokenize(" - 1 2 3 ").to_token_array).to eq(["-", "1", "2", "3"]) 
            expect(@input_parser.tokenize(" 1  2  3 ").to_token_array).to eq(["1", "2", "3"]) 
         end
      end
=end

   end # methods
end