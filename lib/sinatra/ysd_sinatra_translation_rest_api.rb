require 'ysd_md_translation' unless defined?Model::Translation::Translation

module Sinatra
  module YSD
    module TranslationRESTApi
    
      #
      #
      #
      def self.registered(app)
      
        #
        # Helpers
        #
        app.helpers do
          
          #
          # Prepare a content translation for the GUI
          #
          def prepare_translation(translation, language_code)
          
            result = {}
            
            translation.get_translated_attributes(language_code).each do |ct_term|
              result.store(ct_term.concept.to_sym, ct_term.translated_text)
            end
            
            result
                      
          end

        end
      
        #
        # Retrieve a content translation
        #
        app.get "/translation/:language/content/:content_id" do
          
          result = {:language => params[:language], :content_id => params[:content_id] }
          
          if ct=::Model::Translation::CMS::ContentTranslation.get(params[:content_id])
            result.merge!(prepare_translation(ct, params[:language]))
          end
          
          status 200
          content_type :json
          result.to_json
                
        end
        
        #
        # Updates contents translation
        #
        app.put "/translation/content" do
        
          request.body.rewind
          translation_request = JSON.parse(URI.unescape(request.body.read))
          
          language_code = translation_request.delete('language')
          content_id = translation_request.delete('content_id')
          
          content_translation = Model::Translation::CMS::ContentTranslation.create_or_update(content_id, language_code, translation_request)
          
          status 200
          content_type :json
          prepare_translation(content_translation, language_code).to_json
        
        end
      
        #
        # Retrieves a term translation
        #
        app.get "/translation/:language/term/:term_id" do
        
          result = {:language => params[:language], :term_id => params[:term_id]}
          
          if tt=::Model::Translation::CMS::TermTranslation.get(params[:term_id])
            result.merge!(prepare_translation(tt, params[:language]))
          end
          
          status 200
          content_type :json
          result.to_json 
        
        end
        
        #
        # Updates a term translation
        #       
        app.put "/translation/term" do
        
          request.body.rewind
          translation_request = JSON.parse(URI.unescape(request.body.read))
          
          language_code = translation_request.delete('language')
          term_id = translation_request.delete('term_id')
          
          term_translation = ::Model::Translation::CMS::TermTranslation.create_or_update(term_id, language_code, translation_request)
          
          status 200
          content_type :json
          prepare_translation(term_translation, language_code).to_json
        
        end
      
        #
        # Retrieves a menu item translation
        #
        app.get "/translation/:language/menuitem/:menu_item_id" do
        
          result = {:language => params[:language], :menu_item_id => params[:menu_item_id]}
          
          if mitt = ::Model::Translation::Site::MenuItemTranslation.get(params[:menu_item_id])
            result.merge!(prepare_translation(mitt, params[:language]))
          end
          
          status 200
          content_type :json
          result.to_json
        
        end
      
        #
        # Updates a menu item translation
        #
        app.put "/translation/menuitem" do
        
          request.body.rewind
          translation_request = JSON.parse(URI.unescape(request.body.read))
          
          language_code = translation_request.delete('language')
          menu_item_id = translation_request.delete('menu_item_id')
          
          menu_item_translation = ::Model::Translation::Site::MenuItemTranslation.create_or_update(menu_item_id, language_code, translation_request)
          
          status 200
          content_type :json
          prepare_translation(menu_item_translation, language_code).to_json
        
        end
      
      end
    
    end #TranslationRESTApi
  end #YSD
end #Sinatra