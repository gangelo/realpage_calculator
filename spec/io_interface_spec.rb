require 'spec_helper'
require 'pry'

describe "IOInterface" do
   before do
      @service = RealPage::Calculator::IOInterface.new(RealPage::Calculator::CalculatorService.new)

      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::IOInterface.send(:public, *RealPage::Calculator::IOInterface.protected_instance_methods)   
   end

   subject { @service }

   context "methods" do

      describe "#accept" do
         it { should respond_to(:accept).with(0).arguments }
         it "should raise MustOverrideError" do
            expect { @service.accept }.to raise_exception(RealPage::Calculator::MustOverrideError)
         end
      end

      describe "#receive" do
         it { should respond_to(:receive).with(0).arguments }
         it "should raise MustOverrideError" do
            expect { @service.receive }.to raise_exception(RealPage::Calculator::MustOverrideError)
         end
      end

      describe "#respond" do
         it { should respond_to(:respond).with(1).arguments }
         it "should raise MustOverrideError" do
            expect { @service.respond("input") }.to raise_exception(RealPage::Calculator::MustOverrideError)
         end
      end

      describe "#open?" do
         it { should respond_to(:open?).with(0).arguments }
         it "should return false if #accept has not been called or completed successfully" do
            # Simulate @service.accept NOT having been called and/or NOT successfully completed
            @service.instance_variable_set(:@closed, true)
            expect(@service.open?).to be(false) 
         end
         it "should return true if #accept has been called and completed successfully" do
             # Simulate @service.accept having been called, and successfully completed
            @service.instance_variable_set(:@closed, false)
            expect(@service.open?).to be(true) 
         end
      end

      describe "#closed?" do
         it { should respond_to(:closed?).with(0).arguments }
         it "should return true if #accept has not been called or completed successfully" do
            expect(@service.closed?).to be(true) 
         end
      end

      describe "#close" do
         before do
            # Simulate @service.accept having been called, and successfully completed
            @service.instance_variable_set(:@closed, false)
         end

         it { should respond_to(:close).with(0).arguments }
         it "should change #closed? from true to false" do
            expect { @service.close }.to change { @service.closed? }.from(false).to(true)
         end
      end

   end
end