module Sinatra
  module YSD
    module TranslationLanguage
      
      def self.registered(app)
        
        #
        # Translation languages
        #
        app.get "/translationlanguage-management" do
          
          load_page 'translation_language'.to_sym
          
        end
        
      end
      
    end #TranslationLanguage
  end #YSD
end #Sinatra