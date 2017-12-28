require 'i18n'

module RealPage
   module Calculator

      class I18nTranslator

         attr_accessor :operators
         attr_accessor :commands

         def initialize
            self.load_config
         end

         def self.instance
            @@instance
         end

         def locale=(locale)
           I18n.locale = locale
         end

         def locale
            I18n.locale
         end

         def translate(key, scope, translation_args = nil)
            if translation_args.nil?
               I18n.translate key, scope: scope
            else
               I18n.translate key, scope: scope, **translation_args
            end
         end

         def translate_error(error, translation_args = nil)
            error_label = I18n.translate :error_label, scope: :errors
            error_message = self.translate(error[:key], error[:scope], translation_args)
            "#{error_label}: #{error_message}"
         end

         protected

         def load_config
            i18n_folder = File.join(__dir__, '../config/*.yml')
            I18n.load_path = Dir[i18n_folder]
         end

         @@instance = I18nTranslator.new
         private_class_method :new 
      end

   end
end