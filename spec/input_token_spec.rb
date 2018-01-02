require 'spec_helper'

describe "InputToken" do
  before(:each) do
    @input_token = RealPage::Calculator::InputToken.new
    # Change the access modifier on all protected members to public so we can test them.
    RealPage::Calculator::InputToken.send(:public, *RealPage::Calculator::InputToken.protected_instance_methods)
  end

  subject { @input_token }

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
    describe "#token" do
      it "should return the token" do
        @input_token.token = "x"
        expect(@input_token.token).to eq("x")
      end
    end
    describe "#token=" do
      it "should set the token" do
        @input_token.token = "x"
        expect { @input_token.token = "y" }.to change(@input_token, :token).from("x").to("y")
      end
    end
    describe "#operator?" do
      it "should return true if token is a valid operator" do
        RealPage::Calculator::Configuration.instance.operators.each_value do |operator|
          @input_token.token = operator
          expect(@input_token.operator?).to be(true)
        end
      end
      it "should return false if token is not a valid operator" do
        RealPage::Calculator::Configuration.instance.commands.each_value do |command|
          @input_token.token = command
          expect(@input_token.operator?).to be(false)
        end
      end
    end
    describe "#operand?" do
      it "should return true if token is a valid operand" do
        @input_token.token = 1
        expect(@input_token.operand?).to be(true)
      end
      it "should return false if token is not a valid operand" do
        @input_token.token = "x"
        expect(@input_token.operand?).to be(false)
      end
    end
    describe "#command?" do
      it "should return true if token is a valid command" do
        RealPage::Calculator::Configuration.instance.commands.each_value do |command|
          @input_token.token = command
          expect(@input_token.command?).to be(true)
        end
      end
      it "should return false if token is not a valid command" do
        RealPage::Calculator::Configuration.instance.operators.each_value do |operator|
          @input_token.token = operator
          expect(@input_token.command?).to be(false)
        end
      end
    end
    describe "#valid?" do
      it "should return true if token is an operator" do
        @input_token.token = RealPage::Calculator::Configuration.instance.operators.values[0]
        expect(@input_token.valid?).to be(true)
      end
      it "should return true if token is an operand" do
        @input_token.token = 1
        expect(@input_token.valid?).to be(true)
      end
      it "should return true if token is a command" do
        @input_token.token = RealPage::Calculator::Configuration.instance.commands.values[0]
        expect(@input_token.valid?).to be(true)
      end
      it "should return false if token is not an operator, operand or command" do
        @input_token.token = "x"
        expect(@input_token.valid?).to be(false)
      end
    end
    describe "#invalid?" do
      it "should return false if token is an operator" do
        @input_token.token = RealPage::Calculator::Configuration.instance.operators.values[0]
        expect(@input_token.invalid?).to be(false)
      end
      it "should return false if token is an operand" do
        @input_token.token = 1
        expect(@input_token.invalid?).to be(false)
      end
      it "should return false if token is a command" do
        @input_token.token = RealPage::Calculator::Configuration.instance.commands.values[0]
        expect(@input_token.invalid?).to be(false)
      end
      it "should return true if token is not an operator, operand or command" do
        @input_token.token = "x"
        expect(@input_token.invalid?).to be(true)
      end
    end
    describe "#empty?" do
      it "should return true if token is nil or empty" do
        @input_token.token = nil
        expect(@input_token.empty?).to be(true)
        @input_token.token = ""
        expect(@input_token.empty?).to be(true)
      end
    end
    describe "#view_stack?" do
      it "should return true if token equals the view stack command" do
        @input_token.token = view_stack_command
        expect(@input_token.view_stack?).to be(true)
      end
      it "should return false if token does not equal the view stack command" do
        @input_token.token = "not_#{view_stack_command}"
        expect(@input_token.view_stack?).to be(false)
      end
    end
    describe "#clear_stack?" do
      it "should return true if token equals the clear stack command" do
        @input_token.token = clear_stack_command
        expect(@input_token.clear_stack?).to be(true)
      end
      it "should return false if token does not equal the clear stack command" do
        @input_token.token = "not_#{clear_stack_command}"
        expect(@input_token.clear_stack?).to be(false)
      end
    end
    describe "#quit?" do
      it "should return true if token equals the quit command" do
        @input_token.token = quit_command
        expect(@input_token.quit?).to be(true)
      end
      it "should return false if token does not equal the quit command" do
        @input_token.token = "not_#{quit_command}"
        expect(@input_token.quit?).to be(false)
      end
    end
  end # instance methods

  context "class methods" do
    describe "#operators" do
      it "should return the correct operators" do
        expect(RealPage::Calculator::InputToken.operators.count).to eq(RealPage::Calculator::Configuration.instance.operators.count)

        RealPage::Calculator::InputToken.operators.each_key do |operator_key|
          operator_value = RealPage::Calculator::InputToken.operators[operator_key]
          expect(RealPage::Calculator::Configuration.instance.operators[operator_key]).to eq(operator_value)
        end
      end
    end
    describe "#commands" do
      it "should return the correct commands" do
        expect(RealPage::Calculator::InputToken.commands.count).to eq(RealPage::Calculator::Configuration.instance.commands.count)
        RealPage::Calculator::InputToken.commands.each_key do |command_key|
          command_value = RealPage::Calculator::InputToken.commands[command_key]
          expect(RealPage::Calculator::Configuration.instance.commands[command_key]).to eq(command_value)
        end
      end
    end
    describe "#operator?" do
      it "should return true if token is a valid operator" do
        RealPage::Calculator::Configuration.instance.operators.each_key do |operator_key|
          expect(RealPage::Calculator::InputToken.operator?(operator_key)).to be(true)
        end
      end
      it "should return false if token is not a valid operator" do
        RealPage::Calculator::Configuration.instance.operators.each_key do |operator_key|
          not_an_operator_key = "not_an_#{operator_key}"
          expect(RealPage::Calculator::InputToken.operator?(not_an_operator_key)).to be(false)
        end
      end
    end
    describe "#operand?" do
      it "should return true if token is a valid operand" do
        expect(RealPage::Calculator::InputToken.operand?(1)).to be(true)
      end
      it "should return false if token is not a valid operand" do
        expect(RealPage::Calculator::InputToken.operand?("x")).to be(false)
      end
    end
    describe "#valid?" do
      it "should return true if token is an operator" do
        token = RealPage::Calculator::Configuration.instance.operators.values[0]
        expect(RealPage::Calculator::InputToken.valid?(token)).to be(true)
      end
      it "should return true if token is an operand" do
        expect(RealPage::Calculator::InputToken.valid?(1)).to be(true)
      end
      it "should return true if token is a command" do
        token = RealPage::Calculator::Configuration.instance.commands.values[0]
        expect(RealPage::Calculator::InputToken.valid?(token)).to be(true)
      end
      it "should return false if token is not an operator, operand or command" do
        expect(RealPage::Calculator::InputToken.valid?("not_an_operator_operand_or_command")).to be(false)
      end
    end
    describe "#invalid?" do
      it "should return false if token is an operator" do
        token = RealPage::Calculator::Configuration.instance.operators.values[0]
        expect(RealPage::Calculator::InputToken.invalid?(token)).to be(false)
      end
      it "should return false if token is an operand" do
        expect(RealPage::Calculator::InputToken.invalid?(1)).to be(false)
      end
      it "should return false if token is a command" do
        token = RealPage::Calculator::Configuration.instance.commands.values[0]
        expect(RealPage::Calculator::InputToken.invalid?(token)).to be(false)
      end
      it "should return true if token is not an operator, operand or command" do
        expect(RealPage::Calculator::InputToken.invalid?("not_an_operator_operand_or_command")).to be(true)
      end
    end
    describe "#empty?" do
      it "should return true if token is nil" do
        expect(RealPage::Calculator::InputToken.empty?(nil)).to be(true)
      end
      it "should return true if token is an empty string" do
        expect(RealPage::Calculator::InputToken.empty?("")).to be(true)
      end
      it "should return false if token is not nil or an empty string" do
        expect(RealPage::Calculator::InputToken.empty?(1)).to be(false)
      end
    end
    describe "#view_stack?" do
      it "should return true if token is the view stack command" do
        expect(RealPage::Calculator::InputToken.view_stack?(view_stack_command)).to be(true)
      end
      it "should return false if token is not the clear stack command" do
        expect(RealPage::Calculator::InputToken.view_stack?("not_#{view_stack_command}")).to be(false)
      end
    end
    describe "#clear_stack?" do
      it "should return true if token is the clear stack command" do
        expect(RealPage::Calculator::InputToken.clear_stack?(clear_stack_command)).to be(true)
      end
      it "should return false if token is not the clear stack command" do
        expect(RealPage::Calculator::InputToken.clear_stack?("not_#{clear_stack_command}")).to be(false)
      end
    end
    describe "#quit?" do
      it "should return true if token is the quit command" do
        expect(RealPage::Calculator::InputToken.quit?(quit_command)).to be(true)
      end
      it "should return false if token is not the quit command" do
        expect(RealPage::Calculator::InputToken.quit?("not_#{quit_command}")).to be(false)
      end
    end
  end # class methods

end
