require 'spec_helper'

describe "RPNCalculatorService" do
   before(:each) do
      @calculator_service = RealPage::Calculator::RPNCalculatorService.new

      # Change the access modifier on all protected members to public so we can test them.
      RealPage::Calculator::RPNCalculatorService.send(:public, *RealPage::Calculator::RPNCalculatorService.protected_instance_methods)   
   end

   subject { @calculator_service }

    context "instance methods" do
      describe "#compute" do
         it { should respond_to(:compute).with(1).arguments }

         it "should produce the expected output given a string of tokens" do
            expect(@calculator_service.compute("5 8 + 13 -").result).to eq(0.0)
            expect(@calculator_service.compute("-3 -2 * 5 +").result).to eq(11.0)
            expect(@calculator_service.compute("5 9 1 - /").result).to eq(0.625)
            expect(@calculator_service.compute("15 7 1 1 + - / 3 * 2 1 1 + + -").result).to eq(5.0)
         end

         it "should produce the expected output given '5 8 + q' one token at a time" do
            expect(@calculator_service.compute("5").result).to eq(5.0)
            expect(@calculator_service.compute("8").result).to eq(8.0)
            expect(@calculator_service.compute("+").result).to eq(13.0)
            expect(@calculator_service.compute("q").result).to eq("")
         end

         it "should produce the expected output given '5 8 + 13 - q' one token at a time" do
            expect(@calculator_service.compute("5").result).to eq(5.0)
            expect(@calculator_service.compute("8").result).to eq(8.0)
            expect(@calculator_service.compute("+").result).to eq(13.0)
            expect(@calculator_service.compute("13").result).to eq(13.0)
            expect(@calculator_service.compute("-").result).to eq(0.0)
            expect(@calculator_service.compute("q").result).to eq("")
         end

         it "should produce the expected output given '-3 -2 * 5 + q' one token at a time" do
            expect(@calculator_service.compute("-3").result).to eq(-3.0)
            expect(@calculator_service.compute("-2").result).to eq(-2.0)
            expect(@calculator_service.compute("*").result).to eq(6.0)
            expect(@calculator_service.compute("5").result).to eq(5.0)
            expect(@calculator_service.compute("+").result).to eq(11.0)
            expect(@calculator_service.compute("q").result).to eq("")
         end

         it "should produce the expected output given '5 9 1 - / q' one token at a time" do
            expect(@calculator_service.compute("5").result).to eq(5.0)
            expect(@calculator_service.compute("9").result).to eq(9.0)
            expect(@calculator_service.compute("1").result).to eq(1.0)
            expect(@calculator_service.compute("-").result).to eq(8.0)
            expect(@calculator_service.compute("/").result).to eq(0.625)
            expect(@calculator_service.compute("q").result).to eq("")
         end

         it "should return the computed value given a string of tokens that ends with 'quit'" do
            expect(@calculator_service.compute("5 8 + 13 - q").result).to eq(0.0)
         end
      end
   end # instance methods

end