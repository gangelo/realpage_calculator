require 'spec_helper'

describe "InputToken" do
   before do
      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::InputToken.send(:public, *RealPage::Calculator::InputToken.protected_instance_methods)   
   end

   context "initialization" do
      describe "#initialize without parameter" do
          it "should accept no parameter and set #token to nil" do
            @input_token = RealPage::Calculator::InputToken.new
            expect(@input_token.token).to be_nil 
         end
      end
      describe "#initialize with parameter" do
         it "should accept a token parameter and set #token" do
            @input_token = RealPage::Calculator::InputToken.new("1")
            expect(@input_token.token).to eq(1.0) 
         end
      end
   end # initialization
   
   context "instance methods" do
      describe "#token"
      describe "#token="
      describe "#operator?"
      describe "#operand?"
      describe "#valid?"
      describe "#invalid?"
      describe "#empty?"
      describe "#view_stack?"
      describe "#clear_stack?"
      describe "#quit?"
   end # instance methods

   context "class methods" do
      describe "#operators"
      describe "#commands"
      describe "#token"
      describe "#token="
      describe "#operator?"
      describe "#operand?"
      describe "#valid?"
      describe "#invalid?"
      describe "#empty?"
      describe "#view_stack?"
      describe "#clear_stack?"
      describe "#quit?"
   end # class methods

end