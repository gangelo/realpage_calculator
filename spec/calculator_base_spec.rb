require 'spec_helper'

describe "CalculatorBase" do
   before do
      @subject = RealPage::Calculators::CalculatorBase.new RealPage::Calculators::ServiceBase.new
   end

   subject { @subject }

   context "methods" do

      describe "#calculate" do
         it { should respond_to(:calculate).with(1).argument }
         it "should throw MustOverrideError" do
            expect { throw :MustOverrideError }.to throw_symbol(:MustOverrideError) 
         end
      end

   end
end