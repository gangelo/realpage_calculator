require 'spec_helper'

describe "InputParser" do
   before do
      @input_parser = RealPage::Calculator::InputParser.new

      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::InputParser.send(:public, *RealPage::Calculator::InputParser.protected_instance_methods)   
   end

   subject { @input_parser }

   context "instance methods" do
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
      end

      describe "#parse" do
         it { should respond_to(:parse).with(1).arguments }

         it "should raise an MustOverrideError if the method is not overridden" do
            expect { @input_parser.parse("xyz") }.to raise_error(RealPage::Calculator::MustOverrideError)
         end
      end
   end # instance methods

   context "class methods" do
      describe "#contains_quit_command?" do
         it { expect(RealPage::Calculator::InputParser).to respond_to(:contains_quit_command?).with(1).arguments }

         it "should return true if the input contains the quit command" do
            expect(RealPage::Calculator::InputParser.contains_quit_command? quit_command).to eq(true)
         end

         it "should return false if the input does not contain the quit command" do
            expect(RealPage::Calculator::InputParser.contains_quit_command? "not_#{quit_command}").to eq(false)
         end
      end
   end # class methods

end