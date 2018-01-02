module RealPage
  module Calculator

    # Contains all errors to be used in the RealPage::Calculator namespace.
    module Errors
      # The Hash values neccessary to retrieve the error label used for prefixing errors.
      # This hash is used when calling I18nTranslator.instance.translate.
      #
      # @return [Hash] A Hash to be used when calling I18nTranslator.instance.translate
      # in order to obtain the translated error label used for prefixing errors.
      def self.error_label
        { key: :error_label, scope: :errors }
      end

      # Contains all errors to be used specific to CalculatorService objects and
      # derived classes.
      module Calculator
        # The hash values neccessary to retrieve the 'none' error description.
        # This hash is used when calling I18nTranslator.instance.translate.
        #
        # @return [Hash] A Hash to be used when calling I18nTranslator.instance.translate
        # in order to obtain the translated error description.
        NONE = { key: :none, scope: [:errors, :calculator] }

        # The hash values neccessary to retrieve the 'operand expected' error description.
        # This hash is used when calling I18nTranslator.instance.translate.
        #
        # This error should be used when an operand was expected but 'xyz' was encountered.
        #
        # @return [Hash] A Hash to be used when calling I18nTranslator.instance.translate
        # in order to obtain the translated error description.
        OPERAND_EXPECTED = { key: :operand_expected, scope: [:errors, :calculator] }

        # The hash values neccessary to retrieve the 'valid input expected' error description.
        # This hash is used when calling I18nTranslator.instance.translate.
        #
        # This error should be used when a valid operator, operand, or input terminating sequence was expected
        # but 'xyz' was encountered.
        #
        # @return [Hash] A Hash to be used when calling I18nTranslator.instance.translate
        # in order to obtain the translated error description.
        VALID_INPUT_EXPECTED = { key: :valid_input_expected, scope: [:errors, :calculator] }

        # Returns an array of all errors in this namespace.
        #
        # @return [Array<Hash>] An array of all errors in this namespace, each
        # error being a Hash to be used when calling I18nTranslator.instance.translate
        # in order to obtain the translated error description.
        def self.all_errors
          [NONE, OPERAND_EXPECTED, VALID_INPUT_EXPECTED]
        end
      end
    end

  end
end
