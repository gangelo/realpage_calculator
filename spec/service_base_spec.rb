require 'spec_helper'
require 'pry'

describe "Service" do
   before do
      @service = RealPage::Calculators::Service.new(RealPage::Calculators::CalculatorBase.new)
      RealPage::Calculators::Service.send(:public, *RealPage::Calculators::Service.protected_instance_methods)   
   end

   subject { @service }

   context "methods" do

      describe "#accept" do
         it { should respond_to(:accept).with(0).arguments }
         it "should raise MustOverrideError" do
            expect{ @service.accept }.to raise_exception(MustOverrideError)
         end
      end

      describe "#receive" do
         it { should respond_to(:receive).with(0).arguments }
         it "should raise MustOverrideError" do
            expect{ @service.receive }.to raise_exception(MustOverrideError)
         end
      end

      describe "#respond" do
         it { should respond_to(:respond).with(1).arguments }
         it "should raise MustOverrideError" do
            expect{ @service.respond("input") }.to raise_exception(MustOverrideError)
         end
      end

      describe "#close" do
         it { should respond_to(:close).with(0).arguments }
         it "should change #closed? from false to true" do
            expect{ @service.close }.to change { @service.closed? }.from(false).to(true)
         end
      end

   end
end