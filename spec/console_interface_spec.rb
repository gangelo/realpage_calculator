require 'spec_helper'

describe "ConsoleInterface" do
  before(:each) do
    @console_interface = RealPage::Calculator::ConsoleInterface.new(RealPage::Calculator::RPNCalculatorService.new)
    # Change the access modifier on all protected members to public so we can test them.
    RealPage::Calculator::ConsoleInterface.send(:public, *RealPage::Calculator::ConsoleInterface.protected_instance_methods)
    # Suppress output to the console so that we don't muddy our test output
    allow(@console_interface).to receive(:respond).and_return(nil)
  end

  subject { @console_interface }

  context "instance methods" do
    describe "#accept" do
      it { should respond_to(:accept).with(0).arguments }
      it "should change the interface #state from #ready? to #open?" do
        allow(@console_interface).to receive(:receive).and_return(quit_command)
        ready_state = RealPage::Calculator::ConsoleInterface.ready_state
        open_state = RealPage::Calculator::ConsoleInterface.opened_state
        expect { @console_interface.accept }.to change { @console_interface.state }.from(ready_state).to(open_state)
      end
      it "should raise an InterfaceNotReadyError if the interface is not #ready?" do
        if use_readline
          allow(Readline).to receive(:readline).and_return(quit_command)
        else
          allow($stdin).to receive(:gets).and_return(quit_command)
        end
        expect { @console_interface.accept }.to_not raise_error
        expect { @console_interface.accept }.to raise_error(RealPage::Calculator::InterfaceNotReadyError)
      end
    end

    describe "#receive" do
      it { should respond_to(:receive).with(0).arguments }
      it "should receive input from $stdin and return it" do
        # Suppress output to the console so that we don't muddy our test output
        expect(@console_interface).to receive(:respond).and_return(nil)

        input = "1 1 + #{quit_command}\n"
        expect(@console_interface).to receive(:receive).and_return(input)
        if use_readline
          allow(Readline).to receive(:readline).and_return(input)
        else
          allow($stdin).to receive(:gets).and_return(input)
        end
        @console_interface.accept
      end
    end

    describe "#receive_calculator_result" do
      it { should respond_to(:receive_calculator_result).with(1).arguments }
      it "should receive output from the calculator after a compute operation" do
        input = "1 1 + #{quit_command}"
        allow(@console_interface).to receive(:receive).and_return(input)
        expect(@console_interface).to receive(:receive_calculator_result) do |calculator_result|
          expect(calculator_result.result).to eq(2.0)
        end
        @console_interface.accept
      end

      it "should pass output from the calculator to #respond after a compute operation" do
        allow(@console_interface).to receive(:receive).and_return("1 1 + #{quit_command}")
        expect(@console_interface).to receive(:respond).with("2.0\n")
        @console_interface.accept
      end
    end

    describe "#receive_calculator_result_error" do
      it { should respond_to(:receive_calculator_result_error).with(1).arguments }
      it "should receive errors from the calculator" do
        allow(@console_interface).to receive(:receive).and_return("+ + #{quit_command}")
        expect(@console_interface).to receive(:receive_calculator_result_error) do |calculator_result|
          expect(calculator_result.message).to_not eq(CalculatorErrors.none)
        end
        @console_interface.accept
      end

      it "should pass errors from the calculator to #respond_error" do
        allow(@console_interface).to receive(:receive).and_return("+ + #{quit_command}")
        #error_label = RealPage::Calculator::I18nTranslator.instance.translate({ type: :error, key: :error_label, scope: :errors })
        error_label = RealPage::Calculator::I18nTranslator.instance.translate({ type: :error, key: :error_label, scope: [:errors] })

        expect(@console_interface).to receive(:respond_error).with(/#{error_label}/)
        @console_interface.accept
      end
    end

    describe "#display_prompt" do
      it "should display a prompt" do
        expect(@console_interface).to receive(:respond).with(/> /)
        @console_interface.display_prompt
      end

      it "should display a prompt on a new line" do
        expect(@console_interface).to receive(:respond).with(/\n> /)
        @console_interface.display_prompt true
      end
    end
  end # instance methods

end
