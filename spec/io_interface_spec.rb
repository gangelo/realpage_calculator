require 'spec_helper'

describe "IOInterface" do
   before(:each) do
      input_parser = RealPage::Calculator::RPNInputParser
      calculator_service = RealPage::Calculator::CalculatorService.new(input_parser)
      @interface = RealPage::Calculator::IOInterface.new(calculator_service)

      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::IOInterface.send(:public, *RealPage::Calculator::IOInterface.protected_instance_methods)
   end

   subject { @interface }

   context "instance methods" do

      describe "#accept" do
         it { should respond_to(:accept).with(0).arguments }
         it "should return true if the interface has not been previously opened" do
            expect(@interface.accept).to eq(true)
         end
      end

      describe "#accept_async" do
         it "does something special"
      end

      describe "#receive" do
         it { should respond_to(:receive).with(0).arguments }
         it "should raise MustOverrideError" do
            expect { @interface.receive }.to raise_exception(RealPage::Calculator::MustOverrideError)
         end
      end

      describe "#respond" do
         it { should respond_to(:respond).with(1).arguments }
         it "should raise MustOverrideError" do
            expect { @interface.respond("input") }.to raise_exception(RealPage::Calculator::MustOverrideError)
         end
      end

      describe "#ready?" do
         it { should respond_to(:ready?).with(0).arguments }
         it "should return false if #accept has been called and completed successfully" do
            @interface.accept
            expect(@interface.ready?).to be(false) 
         end
         it "should return true if #accept has not been called or not completed successfully" do
            expect(@interface.ready?).to be(true) 
         end
      end

      describe "#open?" do
         it { should respond_to(:open?).with(0).arguments }
         it "should return false if #accept has not been called or completed successfully" do
            expect(@interface.open?).to be(false) 
         end
         it "should return true if #accept has been called and completed successfully" do
            @interface.accept
            expect(@interface.open?).to be(true) 
         end
      end

      describe "#closed?" do
         it { should respond_to(:closed?).with(0).arguments }
         it "should return false if #accept has not been called or completed successfully" do
            expect(@interface.closed?).to be(false) 
         end
         it "should return false if #accept has been called and completed successfully" do
            @interface.accept
            expect(@interface.closed?).to be(false) 
         end
         it "should return true if #accept has been called and completed successfully and #close has been called" do
            @interface.accept
            @interface.close
            expect(@interface.closed?).to be(true) 
         end
      end

      describe "#close" do
         it { should respond_to(:close).with(0).arguments }
         it "should change #closed? from false to true" do
            @interface.accept
            expect { @interface.close }.to change(@interface, :closed?).from(false).to(true)
         end
      end

   end
end