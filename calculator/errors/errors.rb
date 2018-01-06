module RealPage
  module Calculator
    # Contains all errors to be used in the RealPage::Calculator namespace.
    module Errors
      # The Hash values neccessary to retrieve the error label used for
      # prefixing errors. Use this when calling
      # I18nTranslator.instance.translate.
      def self.error_label
        { key: :error_label, scope: :errors }
      end

      # Contains all errors specific to the calculator service.
      module Calculator
        NONE = { key: :none, scope: [:errors, :calculator] }.freeze

        # An operand was expected but 'xyz' was encountered.
        OPERAND_EXPECTED = { key: :operand_expected, scope: [:errors, :calculator] }.freeze

        # A valid operator, operand, or input terminating sequence was expected
        # but 'xyz' was encountered.
        VALID_INPUT_EXPECTED = { key: :valid_input_expected, scope: [:errors, :calculator] }.freeze

        def self.all_errors
          [NONE, OPERAND_EXPECTED, VALID_INPUT_EXPECTED]
        end
      end
    end
  end
end
