require 'spec_helper'

describe "RPNInputParser" do
   before do
      @input_parser = RealPage::Calculator::RPNInputParser.new

      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::RPNInputParser.send(:public, *RealPage::Calculator::RPNInputParser.protected_instance_methods)   
   end

   subject { @input_parser }

   context "methods" do

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
            expect(@input_parser.tokenize("1 1 +").to_token_array).to eq([1.0, 1.0, "+"]) 
            expect(@input_parser.tokenize(" - 1 2 3 ").to_token_array).to eq(["-", 1.0, 2.0, 3.0]) 
            expect(@input_parser.tokenize(" 1  2  3 ").to_token_array).to eq([1.0, 2.0, 3.0]) 
         end
      end

      describe "#nil_or_empty?" do
         it { should respond_to(:nil_or_empty?).with(1).arguments }

         it "should return true if input is nil?" do
            expect(@input_parser.nil_or_empty?(nil)).to eq(true)
         end

         it "should return true if input is empty?" do
            expect(@input_parser.nil_or_empty?("")).to eq(true)
         end

         it "should return true if input is spaces" do
            expect(@input_parser.nil_or_empty?("  ")).to eq(true)
         end

         it "should return false if input is not nil?, empty?, or spaces" do
            expect(@input_parser.nil_or_empty?("1 2 3")).to eq(false)
            expect(@input_parser.nil_or_empty?("1 2 3 +")).to eq(false)
            expect(@input_parser.nil_or_empty?(" 1 2 3 ")).to eq(false)
            expect(@input_parser.nil_or_empty?("+")).to eq(false)
            expect(@input_parser.nil_or_empty?(" -")).to eq(false)
            expect(@input_parser.nil_or_empty?("/ ")).to eq(false)
         end
      end

      describe "#parse" do
         it { should respond_to(:parse).with(1).arguments }

         it "should remove leading and trailing spaces" do
            expect(@input_parser.parse(" x ").to_token_array).to eq(["x"])
         end

         it "should remove double spaces" do
            expect(@input_parser.parse("1  2  3  4").to_token_array).to eq([1.0, 2.0, 3.0, 4.0])
         end
      end

   end
end