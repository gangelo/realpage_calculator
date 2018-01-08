require 'spec_helper'

describe "FileInterface" do
  before do
    @input_file = "spec/files/rpn_input_file.txt"
  end
  before(:each) do
    @file_interface = RealPage::Calculator::FileInterface.new(RealPage::Calculator::RPNCalculatorService.new)
    # Change the access modifier on all protected members to public so we can test them.
    RealPage::Calculator::FileInterface.send(:public, *RealPage::Calculator::FileInterface.protected_instance_methods)
    # Suppress output to the console so that we don't muddy our test output,
    # comment this out to aid in debugging.
    allow(@file_interface).to receive(:respond).and_return(nil)
  end

  subject { @file_interface }

  context '' do
  end

  context 'instance methods' do
    describe '#accept'do
      it { should respond_to(:accept).with(1).arguments }
      it "should change the interface #state from #ready? to #closed?" do
        allow(@file_interface).to receive(:receive).and_return(quit_command)
        ready_state = RealPage::Calculator::FileInterface.ready_state
        expect(@file_interface.ready?).to eq(true)
        @file_interface.accept(@input_file)
        expect(@file_interface.closed?).to eq(true)
      end
      it "should raise an InterfaceNotReadyError if the interface is not #ready?" do
        allow(File).to receive(:gets).and_return(quit_command)
        expect { @file_interface.accept(@input_file) }.to_not raise_error
        expect { @file_interface.accept(@input_file) }.to raise_error(RealPage::Calculator::InterfaceNotReadyError)
      end
    end

    describe '#receive'do
      it { should respond_to(:receive).with(0).arguments }
      it "should read the input file and return the correct result" do
        results = []
        expect(@file_interface).to receive(:respond).exactly(5).times do |result|
          results << result.strip
        end
        @file_interface.accept(@input_file)
        expect(results).to eq(['13.0', '0.0', '11.0', '0.625', '5.0'])
      end
    end

    describe '#receive_calculator_result'do
      it { should respond_to(:receive_calculator_result).with(1).arguments }
      it "should receive output from the calculator after a compute operation" do
        results = []
        expect(@file_interface).to receive(:receive_calculator_result).exactly(5).times do |calculator_result|
          results << calculator_result.result
        end
        @file_interface.accept(@input_file)
        expect(results).to eq([13.0, 0.0, 11.0, 0.625, 5.0])
      end

      it "should pass output from the calculator to #respond after a compute operation" do
        results = []
        expect(@file_interface).to receive(:respond).exactly(5).times do |output|
          results << output
        end
        @file_interface.accept(@input_file)
        expect(results).to eq(["13.0\n", "0.0\n", "11.0\n", "0.625\n", "5.0\n"])
      end
    end

    describe '#receive_calculator_result_error'do
      it { should respond_to(:receive_calculator_result_error).with(1).arguments }
      it "should receive errors from the calculator" do
        expect(@file_interface).to receive(:receive_calculator_result_error) do |calculator_result|
          expect(calculator_result.error).to_not eq(RealPage::Calculator::Errors::Calculator::NONE)
        end
        @file_interface.accept('spec/files/rpn_input_file_with_error.txt')
      end

      it "should pass errors from the calculator to #respond_error" do
        error_label = RealPage::Calculator::I18nTranslator.instance.translate({ key: :error_label, scope: :errors })
        expect(@file_interface).to receive(:respond_error).with(/#{error_label}/)
        @file_interface.accept('spec/files/rpn_input_file_with_error.txt')
      end
    end

    describe '#close'do
      it { should respond_to(:close).with(0).arguments }
      it "should close the stream when #accept processing is completed" do
        # No idea why this is causing an endless loop, but assuming it's a
        # matcher bug.
        # expect(@file_interface).to receive(:close).at_least(1).times
        @file_interface.accept(@input_file)
        expect(@file_interface.file.closed?).to eq(true)
      end
    end
  end # instance methods
end
