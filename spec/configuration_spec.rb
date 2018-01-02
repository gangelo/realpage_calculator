require 'spec_helper'

describe "Configuration" do
  before(:each) do
    @configuraiton = RealPage::Calculator::Configuration.instance
    # Change the access modifier on all protected members to public so we can test them.
    RealPage::Calculator::Configuration.send(:public, *RealPage::Calculator::Configuration.protected_instance_methods)
  end

  subject { @configuraiton }

  context "public instance methods" do
    describe "#quit_command" do
      it "should return the quit command" do
        expect(@configuraiton.quit_command).to_not eq(nil)
      end
    end

    describe "#clear_stack_command" do
      it "should return the clear stack command" do
        expect(@configuraiton.clear_stack_command).to_not eq(nil)
      end
    end

    describe "#view_stack_command" do
      it "should return the view stack command" do
        expect(@configuraiton.view_stack_command).to_not eq(nil)
      end
    end
  end # public instance methods

  context "public class methods" do
    describe "#instance" do
      it "should return the Configuration instance" do
        expect(@configuraiton).to be_a RealPage::Calculator::Configuration
      end
    end
  end # public class methods

end
