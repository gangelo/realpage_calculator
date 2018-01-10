require 'i18n'

module RealPage
  module Calculator
    # Provides a single(ton) interface for translation.
    class I18nTranslator
      # Initializes an object of this type.
      def initialize
        load_config
      end

      def instance
        self.class.instance
      end

      def locale=(locale)
        I18n.locale = locale
      end

      def locale
        I18n.locale
      end

      # Returns the translation given the key, scope, and optional arguments
      # used in the translation.
      def translate(key_scope_hash, translation_args_hash = nil)
        if key_scope_hash.nil?
          return I18n.translate(:not_found, scope: :defaults)
        end
        
        key = key_scope_hash[:key]
        scope = key_scope_hash[:scope]

        if translation_args_hash.nil?
          I18n.translate(key, scope: scope)
        else
          I18n.translate(key, scope: scope, **translation_args_hash)
        end
      end

      protected

      def load_config
        i18n_folder = File.join(__dir__, '../config/i18n.yml')
        I18n.load_path = Dir[i18n_folder]
      end

      class << self
        attr_reader :instance
      end

      @instance = I18nTranslator.new
      private_class_method :new
    end
  end
end
