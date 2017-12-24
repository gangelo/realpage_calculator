require 'spec_helper'

describe "InputToken" do
   before do
      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::InputToken.send(:public, *RealPage::Calculator::InputToken.protected_instance_methods)   
   end

   subject { @interface }

   context "initialization" do
      describe "#initialize" do
         before do
            @input_token = RealPage::Calculator::InputToken.new
         end

         subject { @input_token }

         it { should respond_to(:initialize).with(1).arguments }
      end
   end
   
   context "instance methods" do
      describe "" do
      end
   end

end