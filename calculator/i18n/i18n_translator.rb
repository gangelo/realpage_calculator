require 'i18n'

module RealPage
  module Calculator
    # Singleton. Provides a single interface for translation.
    class I18nTranslator
      # Initializes an object of this type.
      def initialize
        load_config
      end

      # Returns the I18nTranslator instance.
      #
      # @return [I18nTranslator] Returns the single(ton) instance of
      # this I18nTranslator object.
      def self.instance
        @@instance
      end

      # Manually sets the current locale.
      #
      # @param [Symbol] locale The locale to set (e.g. :en, :de, etc.)
      def locale=(locale)
        I18n.locale = locale
      end

      # Returns the current locale.
      #
      # @return [Symbol] Returns the current locale.
      def locale
        I18n.locale
      end

      # Returns the translated text given the key, scope, and optional
      # additional arguments used in the translation.
      #
      # @param [Hash] key_scope_hash A Hash containing values for :key
      # and :scope.
      #
      # @param [Hash] translation_args_hash A hash containing additional
      # arguments used in the translation.
      #
      # @return [String] Returns the translated string.
      def translate(key_scope_hash, translation_args_hash = nil)
        if key_scope_hash.nil?
          # If no key and scope sent, return the deafult (:not_found)
          return I18n.translate :not_found, scope: :defaults
        end

        # Get the key and scope of the translation we need.
        key = key_scope_hash[:key]
        scope = key_scope_hash[:scope]

        if translation_args_hash.nil?
          I18n.translate key, scope: scope
        else
          # If there are traslation arguments to pass along for translation
          # use the double splat to pass them alond to the translator
          # as hash arguments.
          I18n.translate key, scope: scope, **translation_args_hash
        end
      end

      protected

      # Loads the translation values from the translation yaml file.
      def load_config
        i18n_folder = File.join(__dir__, '../config/i18n.yml')
        I18n.load_path = Dir[i18n_folder]
      end

      @@instance = I18nTranslator.new
      private_class_method :new
    end
  end
end
