require 'ysd-plugins' unless defined?Plugins::Plugin

Plugins::SinatraAppPlugin.register :translation do

   name=        'translation'
   author=      'yurak sisa'
   description= 'Translation'
   version=     '0.1'
   sinatra_extension Sinatra::YSD::TranslationLanguage
   sinatra_extension Sinatra::YSD::TranslationLanguageRESTApi   
   hooker Huasi::TranslationExtension
end