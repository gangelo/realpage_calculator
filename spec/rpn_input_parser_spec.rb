require 'spec_helper'

describe "RPNInputParser" do
  before do
    @input_parser = RealPage::Calculator::RPNInputParser.new

    # Change the access modifier on all protected members to public so we can test them.
    RealPage::Calculator::RPNInputParser.send(:public, *RealPage::Calculator::RPNInputParser.protected_instance_methods)
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

      it "should convert string input to a token array" do
        input_token_array = @input_parser.tokenize('1 1 +')
        expect(input_token_array.map(&:token)).to eq([1.0, 1.0, '+'])

        input_token_array = @input_parser.tokenize(' - 1 2 3 ')
        expect(input_token_array.map(&:token)).to eq(['-', 1.0, 2.0, 3.0])

        input_token_array = @input_parser.tokenize(' 1 / 2 * 3 ')
        expect(input_token_array.map(&:token)).to eq([1.0, '/', 2.0, '*', 3.0])
      end
    end

    describe "#parse" do
      it { should respond_to(:parse).with(1).arguments }

      it "should remove leading and trailing spaces" do
        input_token_array = @input_parser.tokenize(' x ')
        expect(input_token_array.map(&:token)).to eq(['x'])
      end

      it "should remove double spaces" do
        input_token_array = @input_parser.tokenize(' 1    2  3        4    ')
        expect(input_token_array.map(&:token)).to eq([1.0, 2.0, 3.0, 4.0])
      end
    end

    describe "#contains_quit_command?" do
      it { expect(@input_parser).to respond_to(:contains_quit_command?).with(1).arguments }

      it "should return true if the input contains the quit command" do
        expect(@input_parser.contains_quit_command? quit_command).to eq(true)
      end

      it "should return true if the input contains the quit command as part of a series of input tokens" do
        expect(@input_parser.contains_quit_command? "1 1 + #{quit_command}").to eq(true)
      end

      it "should return false if the input does not contain the quit command" do
        expect(@input_parser.contains_quit_command? "not_#{quit_command}").to eq(false)
      end

      it "should return false if the input does not contain the quit command as part of a series of input tokens" do
        expect(@input_parser.contains_quit_command? "1 1 + not_#{quit_command}").to eq(false)
      end
    end

    describe "#quit_command?" do
      it { expect(@input_parser).to respond_to(:quit_command?).with(1).arguments }

      it "should return true if the input is the quit command" do
        expect(@input_parser.quit_command? quit_command).to eq(true)
      end

      it "should return false if the input is not the quit command" do
        expect(@input_parser.quit_command? "not_#{quit_command}").to eq(false)
      end

      it "should return false if the input contains the quit command as part of a series of input tokens" do
        expect(@input_parser.quit_command? "1 1 + #{quit_command}").to eq(false)
      end
    end
  end # instance methods

  context "class methods" do
    describe "#to_token_array" do
      it { expect(RealPage::Calculator::RPNInputParser).to respond_to(:to_token_array).with(1).arguments }

      it "should return an array of tokens given an array of InputTokens" do
        input_token_array = [
          RealPage::Calculator::InputToken.new("x"),
          RealPage::Calculator::InputToken.new("y"),
          RealPage::Calculator::InputToken.new("z")
        ]
        expect(RealPage::Calculator::RPNInputParser.to_token_array input_token_array).to eq(["x", "y", "z"])
      end

      it "should return [] if the input array is nil? or contains no elements" do
        expect(RealPage::Calculator::RPNInputParser.to_token_array nil).to eq([])
        expect(RealPage::Calculator::RPNInputParser.to_token_array []).to eq([])
      end

      it "should raise an ArgumentError unless all of the input array elements respond_to? :token" do
        bad_input_array = [
          RealPage::Calculator::InputToken.new("x"),
          "y",
          RealPage::Calculator::InputToken.new("z")
        ]
        expect { RealPage::Calculator::RPNInputParser.to_token_array bad_input_array }.to raise_error(ArgumentError, /does not implement method #token/)
      end
    end
  end # class methods

end
