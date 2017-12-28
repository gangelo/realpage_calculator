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

         #
         # Returns the translated text given a key, scope and
         # optional translation arguments.
         #
         #
         def translate(key_scope_hash, translation_args_hash = nil)
            if key_scope_hash.nil?
               return I18n.translate :default
            end

            key = key_scope_hash[:key]
            scope = key_scope_hash[:scope]

            if translation_args_hash.nil?
               I18n.translate key, scope: scope
            else
               I18n.translate key, scope: scope, **translation_args_hash
            end
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