module RealPage
  module Calculator
    # Contains all messages to be used in the RealPage::Calculator namespace.
    module Messages
      # The Hash values neccessary to retrieve the warning label used for
      # prefixing warnings. Use this when calling
      # I18nTranslator.instance.translate.
      def self.warning_label 
        { key: :warning_label, scope: :warnings }
      end

      # The Hash values neccessary to retrieve the error label used for
      # prefixing errors. Use this when calling
      # I18nTranslator.instance.translate.
      def self.error_label
        { key: :error_label, scope: :errors }
      end
      
      module Calculator
        # Contains all errors specific to the calculator service.
        module Errors
          def self.none 
            { type: :error, key: :none, scope: [:errors, :calculator] }
          end
          def self.operand_expected
            { type: :error, key: :operand_expected, scope: [:errors, :calculator] }
          end
          def self.valid_input_expected
            { type: :error, key: :valid_input_expected, scope: [:errors, :calculator] }
          end
          def self.all_errors
            [none, operand_expected, valid_input_expected]
          end
        end
        # Contains all warnings specific to the calculator service.
        module Warnings
          def self.none 
            { type: :warning, key: :none, scope: [:warnings, :calculator] }
          end
          def self.infinite_result 
            { type: :warning, key: :infinite_result, scope: [:warnings, :calculator] }
          end
          def self.all_warnings 
            [none, infinite_result]
          end
        end
      end
    end
  end
end

CalculatorErrors = RealPage::Calculator::Messages::Calculator::Errors
CalculatorWarnings = RealPage::Calculator::Messages::Calculator::Warnings
